//
//  CollectionViewLayout.swift
//  MPC
//
//  Created by Krishna Venkatramani on 27/03/2023.
//

import Foundation
import UIKit

public extension NSCollectionLayoutSection {
    
    static func singleRow(_ size: NSCollectionLayoutSize,
                          spacing: CGFloat,
                          insets: NSDirectionalEdgeInsets,
                          scrollable: Bool = true) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = insets
        
        return section
    }

    static func singleColumn(_ size: NSCollectionLayoutSize,
                             spacing: CGFloat,
                             insets: NSDirectionalEdgeInsets) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = insets
        
        return section
    }
    
    static func twoByTwoGrid(_ height: NSCollectionLayoutDimension,
                             spacing: CGFloat,
                             interItemSpacing: CGFloat,
                             insets: NSDirectionalEdgeInsets
    ) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5),
                                                            heightDimension: height))
        
        let groupSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1), heightDimension: height)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(interItemSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = insets
        return section
    }
    
    static func singleDynamicGroup(_ itemSize: NSCollectionLayoutSize,
                                   groupHeight: NSCollectionLayoutDimension = .estimated(200),
                                   spacing: CGFloat,
                                   interItemSpacing: CGFloat,
                                   insets: NSDirectionalEdgeInsets
    ) -> NSCollectionLayoutSection {
        let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
        
        let groupSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1),
                                                      heightDimension: groupHeight)
        let group: NSCollectionLayoutGroup = .horizontal(layoutSize: groupSize,
                                                         subitems: [item])
        group.interItemSpacing = .fixed(interItemSpacing)
        
        let section: NSCollectionLayoutSection = .init(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = insets
        return section
    }
}
