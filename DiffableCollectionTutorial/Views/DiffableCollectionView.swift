//
//  DiffableCollectionView.swift
//  DiffableCollectionTutorial
//
//  Created by James Rochabrun on 6/7/21.
//

import UIKit

final class DiffableCollectionView<Section: SectionIdentifierRepresentable>: UIView {

    // MARK:- UI
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    private var layout: UICollectionViewLayout = UICollectionViewFlowLayout()

    // MARK:- LifeCycle
    convenience init(layout: UICollectionViewLayout) {
        self.init()
        self.layout = layout
        translatesAutoresizingMaskIntoConstraints = false
        collectionView.collectionViewLayout = layout
        setupViews()
    }

    private func setupViews() {
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
        ])
    }

    // MARK:- DataSource
    typealias SectionIdentifier = Section.SectionIdentifier // defines a section
    typealias CellIdentifier = Section.CellIdentifier // defines an item in a section

    typealias DiffDataSource = UICollectionViewDiffableDataSource<SectionIdentifier, CellIdentifier>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionIdentifier, CellIdentifier>

    private var currentSnapshot: Snapshot?
    private var dataSource: DiffDataSource?

    // MARK:- Public
    typealias HeaderFooterProvider = (UICollectionView, SectionIdentifier, String, IndexPath) -> UICollectionReusableView?
    typealias CellProvider = (UICollectionView, IndexPath, CellIdentifier) -> UICollectionViewCell

    /// Source of the content that will be injected in cells and supplementary views.
    /// - parameter animated: Bool that defines if a snapshot should execute an animated snapshot update
    /// - parameter content: function builder that expects sections, for more go to `DiffableDataSourceBuilder` struct definition
    func update(
        animated: Bool = false,
        @DiffableDataSourceBuilder<Section> _ content: () -> [Section]) {

        let sectionItems = content()
        currentSnapshot = Snapshot()
        guard var currentSnapshot = currentSnapshot else { return }
        currentSnapshot.appendSections(sectionItems.map { $0.sectionIdentifier })
        sectionItems.forEach { currentSnapshot.appendItems($0.cellIdentifiers, toSection: $0.sectionIdentifier) }
        self.currentSnapshot = currentSnapshot

        if #available(iOS 15.0, *) { // Testing, will investigate more.
            dataSource?.applySnapshotUsingReloadData(currentSnapshot)
        } else {
            dataSource?.apply(currentSnapshot, animatingDifferences: animated)
        }
    }

    func cellProvider(
        _ cellProvider: @escaping CellProvider) {
        dataSource = DiffDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            cellProvider(collectionView, indexPath, model)
        })
    }

    func supplementaryViewProvider(
        _ headerFooterProvider: @escaping HeaderFooterProvider)  {
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let sectionIdentifier = self?.dataSource?.snapshot().sectionIdentifiers[indexPath.section] else { return nil }
            return headerFooterProvider(collectionView, sectionIdentifier, kind, indexPath)
        }
    }
}

