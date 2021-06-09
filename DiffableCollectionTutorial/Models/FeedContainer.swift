//
//  FeedContainer.swift
//  DiffableCollectionTutorial
//
//  Created by James Rochabrun on 6/7/21.
//

import Foundation

struct Container<Item: Decodable>: Decodable {
    let feed: ContainerFeed<Item>
}

struct ContainerFeed<Item: Decodable>: Decodable {
    let results: [Item]
}
