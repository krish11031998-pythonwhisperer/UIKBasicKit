//
//  CollectionDataSource.swift
//  ZeamFinance
//
//  Created by Krishna Venkatramani on 04/10/2022.
//

import Foundation
import UIKit

public class CollectionDataSource: NSObject {
    let sections: [CollectionSection]
    let headers: [NSCollectionLayoutBoundarySupplementaryItem]?
    let footer: [NSCollectionLayoutBoundarySupplementaryItem]?
    let compositionalLayout: Bool
    
    public init(sections: [CollectionSection],
         headers: [NSCollectionLayoutBoundarySupplementaryItem]? = nil,
         footer: [NSCollectionLayoutBoundarySupplementaryItem]? = nil,
         compositionalLayout: Bool = false
    ) {
        self.sections = sections
        self.headers = headers
        self.footer = footer
        self.compositionalLayout = compositionalLayout
    }
}

extension CollectionDataSource: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].cell.count
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        sections[indexPath.section].cell[indexPath.row].collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        sections[indexPath.section].collectionView(collectionView, kind: kind, at: indexPath)
    }
}

extension CollectionDataSource: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sections[indexPath.section].cell[indexPath.row].collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard  sections.count > indexPath.section && sections[indexPath.section].cell.count > indexPath.row else { return }
        sections[indexPath.section].cell[indexPath.row].collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.section < sections.count && sections[indexPath.section].cell.count > indexPath.row else { return }
        sections[indexPath.section].cell[indexPath.row].collectionView(collectionView, didEndDisplaying: cell, forItemAt: indexPath)
    }
}

extension CollectionDataSource: UICollectionViewDataSourcePrefetching {
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for idx in indexPaths {
            sections[idx.section].cell[idx.item].prefetch()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for idx in indexPaths {
            sections[idx.section].cell[idx.item].cancelPrefetch()
        }
    }
}

extension CollectionDataSource: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.cellForItem(at: indexPath)
        let size = (collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize ?? cell?.compressedSize ?? .zero
        return size
        
    }
}
