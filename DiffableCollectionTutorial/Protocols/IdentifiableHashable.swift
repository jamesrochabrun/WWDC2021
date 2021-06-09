//
//  IdentifiableHashable.swift
//  DiffableCollectionTutorial
//
//  Created by James Rochabrun on 6/7/21.
//

import Foundation

protocol IdentifiableHashable: Hashable & Identifiable {}
extension IdentifiableHashable {
    static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
