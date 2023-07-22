//
//  CollectionColumn.swift
//  ZeamFinance
//
//  Created by Krishna Venkatramani on 04/10/2022.
//

import Foundation
import UIKit

//MARK: - CollecitonCellDisplay
public protocol CollectionCellDisplay {
    func willDisplay()
    func endDisplay()
}

public extension CollectionCellDisplay {
    func willDisplay() {}
    func endDisplay() {}
}
//MARK: - ConfigurableCollectionCell

public typealias ConfigurableCollectionCell = Configurable & UICollectionViewCell & CollectionCellDisplay

//MARK: - CollectionCellProvider

public protocol CollectionCellProvider {
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    func prefetch()
    func cancelPrefetch()
}

//MARK: - CollectionItem
public class CollectionItem<Cell:ConfigurableCollectionCell>: CollectionCellProvider {
	var model: Cell.Model
	
	public init(_ model: Cell.Model) {
		self.model = model
	}
	
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: Cell = collectionView.dequeueCell(Cell.cellName ?? Cell.name, indexPath: indexPath)
		cell.configure(with: model)
		return cell
	}
	
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
		if let action = model as? ActionProvider {
            if action.bounceOnClick {
                //cell.layer.animate(.bouncy, removeAfterCompletion: true)
            }
			action.action?()
            let cellOrigin = cellFrame(collection: collectionView, cell: cell)
            action.actionWithFrame?(.init(origin: cellOrigin, size: cell.frame.size))
		}
	}
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let validCell = cell as? CollectionCellDisplay else { return }
        validCell.willDisplay()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let validCell = cell as? CollectionCellDisplay else { return }
        validCell.endDisplay()
    }
    
    public func prefetch() { Cell.prefetch(with: model) }
    
    public func cancelPrefetch() { Cell.cancelPrefetch(with: model) }
    
}


//MARK: - CollectionColumn Helpers

extension CollectionItem {
    
    func cellFrame(collection: UICollectionView, cell: UICollectionViewCell) -> CGPoint {
        guard let superView = collection.superview else { return .zero }
        let cellOrigin = cell.convert(superView.frame.origin, to: nil)
        return cellOrigin
    }
    
}
