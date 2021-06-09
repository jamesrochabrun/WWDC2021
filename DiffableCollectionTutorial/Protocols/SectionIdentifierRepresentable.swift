//
//  SectionIdentifierRepresentable.swift
//  DiffableCollectionTutorial
//
//  Created by James Rochabrun on 6/7/21.
//

import Foundation

protocol SectionIdentifierRepresentable: AnyObject {
    associatedtype SectionIdentifier: Hashable
    associatedtype CellIdentifier: Hashable
    var sectionIdentifier: SectionIdentifier { get }
    var cellIdentifiers: [CellIdentifier] { get }
}
