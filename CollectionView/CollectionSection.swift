//
//  CollectionSection.swift
//  ZeamFinance
//
//  Created by Krishna Venkatramani on 04/10/2022.
//

import Foundation
import UIKit

public class CollectionSection {
	let cell: [CollectionCellProvider]
	let customHeader: CollectionSupplementaryProvider?
	let customFooter: CollectionSupplementaryProvider?
	let title: String?
    let layout: NSCollectionLayoutSection?
	
	public init(cell: [CollectionCellProvider],
		 customHeader: CollectionSupplementaryProvider? = nil,
		 customFooter: CollectionSupplementaryProvider? = nil,
         title: String? = nil,
         layout: NSCollectionLayoutSection? = nil) {
		self.cell = cell
		self.customHeader = customHeader
		self.customFooter = customFooter
		self.title = title
        self.layout = layout
	}
}

public extension CollectionSection {
    
    func collectionView(_ collectionView: UICollectionView, kind: String, at: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if let header = customHeader {
                return header.collectionView(collectionView, kind: kind, at: at)
            }
        case UICollectionView.elementKindSectionFooter:
            if let header = customFooter {
                return header.collectionView(collectionView, kind: kind, at: at)
            }
        default:
            break
        }
        return .init()
    }
    
}


