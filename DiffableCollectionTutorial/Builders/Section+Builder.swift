//
//  Section+Builder.swift
//  DiffableCollectionTutorial
//
//  Created by James Rochabrun on 6/7/21.
//

import Foundation

// MARK:- Function Builder
@resultBuilder
struct DiffableDataSourceBuilder<Section: SectionIdentifierRepresentable>   {
    static func buildBlock(_ sections: Section...) -> [Section] { sections }
    static func buildBlock(_ components: [Section]...) -> [Section] { components.flatMap { $0 } }
}
