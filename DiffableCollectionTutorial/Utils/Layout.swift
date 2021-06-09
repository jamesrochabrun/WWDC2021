//
//  Layout.swift
//  DiffableCollectionTutorial
//
//  Created by James Rochabrun on 6/7/21.
//

import UIKit

extension UICollectionViewCompositionalLayout {

    static func list() -> UICollectionViewLayout {

         UICollectionViewCompositionalLayout(sectionProvider: {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            NSCollectionLayoutSection.listWith(
                heightGroupDimension: .estimated(100),
                headerHeightDimension: .estimated(200), header: sectionIndex == 1)

        })
    }
}

extension NSCollectionLayoutSection {

    static func listWith(
        heightGroupDimension: NSCollectionLayoutDimension,
        headerHeightDimension: NSCollectionLayoutDimension,
        header: Bool = false,
        footer: Bool = false)
        -> NSCollectionLayoutSection
    {
        // 2
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: heightGroupDimension)
        // 3
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        // 4
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                     heightDimension: heightGroupDimension)
        // 5
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize,
                                                             subitems: [layoutItem])

        // 6
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)

        layoutSection.boundarySupplementaryItems = supplementaryItems(header: header, footer: footer, headerHeightDimension: headerHeightDimension)

        return layoutSection
    }

    private static func supplementaryItems(
        header: Bool,
        footer: Bool,
        headerHeightDimension: NSCollectionLayoutDimension)
        -> [NSCollectionLayoutBoundarySupplementaryItem]
    {
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: headerHeightDimension) // <- estimated will dynamically adjust to less height if needed.
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind:  UICollectionView.elementKindSectionFooter, alignment: .bottom)
        var supplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = []
        if header {
            supplementaryItems.append(sectionHeader)
        }
        if footer {
            supplementaryItems.append(sectionFooter)
        }
        return supplementaryItems
    }

}
