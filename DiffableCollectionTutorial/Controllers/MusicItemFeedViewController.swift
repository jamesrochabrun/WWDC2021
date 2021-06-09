//
//  MusicItemFeedViewController.swift
//  DiffableCollectionTutorial
//
//  Created by James Rochabrun on 6/7/21.
//

import UIKit
import Combine

// MARK:- Section Configuration
final class MusicItemFeedIdentifier: SectionIdentifierRepresentable {

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
    let remote = FeedRemote()
    var cancellables = Set<AnyCancellable>()

    // MARK:- UI
    private lazy var diffableCollectionView: DiffableCollectionView<MusicItemFeedIdentifier> = {
            .init(layout: UICollectionViewCompositionalLayout.list())
    }()

    // MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        performFetch()
    }

    // MARK:- Private
    private func performFetch() {
        if #available(iOS 15, *) {
            remote.fetchMusicItems()
        }
        remote.$musicItems.sink { [weak self] items in
            guard let self = self else { return }
            self.diffableCollectionView.update(animated: true) {
                MusicItemFeedIdentifier(sectionIdentifier: .main, cellIdentifiers: items)
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

        diffableCollectionView.cellProvider { collectionView, indexPath, model in
            collectionView.dequeueAndConfigureReusableCell(with: model, at: indexPath) as MusicItemCell
        }
    }
}

