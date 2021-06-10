//
//  FeedRemote.swift
//  DiffableCollectionTutorial
//
//  Created by James Rochabrun on 6/7/21.
//

import Combine
import UIKit


@MainActor
final class FeedRemote: ObservableObject {

    private let client = Client()
    @Published var musicItems: [MusicItemViewModel] = []

    var request: URLRequest = {
        let urlString = "https://rss.itunes.apple.com/api/v1/us/apple-music/coming-soon/all/50/explicit.json"
        let url = URL(string: urlString)!
        return URLRequest(url: url)
    }()

    @available(iOS 15, *)
    func fetchMusicItems() {
        test()
//        async {
//            do {
//                let container = try await client.fetch(type: Container<MusicItem>.self, with: request)
//                musicItems = container.feed.results.map { MusicItemViewModel(musicItem: $0) }
//            } catch {
//                print("zizou \((error as! APIError).customDescription)")
//            }
//        }
    }

    func test() {

        client.fetch(type: Container<MusicItem>.self, with: request) { res in

            switch res {
            case .success(let container):
                self.musicItems = container.feed.results.map { MusicItemViewModel(musicItem: $0) }
            case .failure: fatalError()
            }
        }
    }
}

