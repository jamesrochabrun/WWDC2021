//
//  MusicItemFeedViewController.swift
//  DiffableCollectionTutorial
//
//  Created by James Rochabrun on 6/7/21.
//

import UIKit
import Combine

// MARK:- Section Configuration
final class MusicItemFeedIdentifier: SectionIdentifierRepresentable, Identifiable {

    let sectionIdentifier: MusicItemFeedSection
    var cellIdentifiers: [MusicItemViewModel]

    enum MusicItemFeedSection {
        case main
    }

    init(sectionIdentifier: MusicItemFeedSection, cellIdentifiers: [MusicItemViewModel]) {
        self.sectionIdentifier = sectionIdentifier
        self.cellIdentifiers = cellIdentifiers
    }
}

class MusicItemFeedViewController: UIViewController {

    // MARK:- Remote
    private let remote = FeedRemote()
    private var cancellables = Set<AnyCancellable>()

    // MARK:- UI
    private lazy var diffableCollectionView: DiffableCollectionView<MusicItemFeedIdentifier> = {
            .init(layout: UICollectionViewCompositionalLayout.list())
    }()

    // MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        performNewCellRegistration()
        configureCollectionView()
        performFetch()
    }

    // MARK:- Private
    private func performFetch() {
        if #available(iOS 15, *) {
            self.remote.fetchMusicItems()
        }

        remote.$musicItems.sink { value in
            dump(value)
        } receiveValue: { [weak self] items in
            guard let self = self else { return }
            self.diffableCollectionView.update(animated: true) {
                MusicItemFeedIdentifier(sectionIdentifier: .main, cellIdentifiers: items)//.map { $0.id })
            }
        }.store(in: &cancellables)
    }

    private func configureCollectionView() {

        view.addSubview(diffableCollectionView)
        NSLayoutConstraint.activate([
            diffableCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            diffableCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: diffableCollectionView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: diffableCollectionView.bottomAnchor)
        ])
    }

    func performNewCellRegistration() {

        let cellRegistration = UICollectionView.CellRegistration<MusicItemCell, MusicItemViewModel> { cell, indexPath, itemIdentifier in
            cell.configureWithViewModel(itemIdentifier)
        }

        diffableCollectionView.cellProvider { collectionView, indexPath, model in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: model)
        }
    }
}
