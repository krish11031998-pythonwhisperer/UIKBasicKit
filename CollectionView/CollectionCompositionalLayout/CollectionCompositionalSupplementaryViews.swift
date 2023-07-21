//
//  CollectionCompositionalSupplementaryViews.swift
//  MPC
//
//  Created by Krishna Venkatramani on 27/03/2023.
//

import Foundation
import UIKit

public extension NSCollectionLayoutBoundarySupplementaryItem {
    
    static func defaultHeader(height: NSCollectionLayoutDimension = .absolute(32)) ->  NSCollectionLayoutBoundarySupplementaryItem {
        return .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                       heightDimension: height),
                     elementKind: UICollectionView.elementKindSectionHeader,
                     alignment: .top)
    }
    
    static func defaultFooter(height: NSCollectionLayoutDimension = .absolute(32)) ->  NSCollectionLayoutBoundarySupplementaryItem {
        return .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                       heightDimension: height),
                     elementKind: UICollectionView.elementKindSectionFooter,
                     alignment: .bottom)
    }
    
}
