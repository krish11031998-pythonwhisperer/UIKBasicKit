//
//  CollectionViewFunctions.swift
//  ZeamFinance
//
//  Created by Krishna Venkatramani on 04/10/2022.
//

import Foundation
import UIKit

//MARK: - CollectionSectionTransaction
public extension CollectionSection {
    enum Transactions {
        case delete(at: Int)
        case insert(_ section: CollectionSection, at: Int)
        case reload(_ section: CollectionSection, at: Int)
    }
}
//MARK: - CollectionView Functions
public extension UICollectionView {
	
	private static var propertyKey: UInt8 = 1
	
	private(set) var source: CollectionDataSource? {
		get { return objc_getAssociatedObject(self, &Self.propertyKey) as? CollectionDataSource }
		set { objc_setAssociatedObject(self, &Self.propertyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}
	
    func dequeueCell<Cell:UICollectionViewCell>(_ name: String = Cell.name, indexPath: IndexPath) -> Cell {
		self.register(Cell.self, forCellWithReuseIdentifier: Cell.name)
        guard let cell = dequeueReusableCell(withReuseIdentifier: Cell.name, for: indexPath) as? Cell else {
			return Cell()
		}
		return cell
	}
	
    
    func dequeueReusableSupplementaryView<View: UICollectionReusableView>(ofKind: String, withIdentifier: String, for indexPath: IndexPath) -> View {
        self.register(View.self, forSupplementaryViewOfKind: ofKind, withReuseIdentifier: withIdentifier)
        guard let view = dequeueReusableSupplementaryView(ofKind: ofKind, withReuseIdentifier: withIdentifier, for: indexPath) as? View else {
            return View()
        }
        return view
    }
	
    func reloadData(_ dataSource: CollectionDataSource, preserveContentOffset: Bool = false, completion: Callback? = nil) {
		self.source = dataSource
		self.dataSource = dataSource
		self.delegate = dataSource
        self.prefetchDataSource = dataSource
        var preservedContentOffset: CGPoint? = nil
        if preserveContentOffset {
            preservedContentOffset = contentOffset
        }
        if dataSource.compositionalLayout {
            buildLayout { [weak self] in
                guard let self else { return }
                self.performBatchUpdates {
                    self.reloadData()
                    if preserveContentOffset, let off = preservedContentOffset,
                       off.x < self.contentSize.width && off.y < self.contentSize.height {
                        self.contentOffset = off
                    }
                }
            }
        } else {
            self.reloadData()
        }
	}
    
    func reloadSection(_ section: CollectionSection, at sectionIdx: Int) {
        var sections = self.source?.sections ?? []
        if sectionIdx > sections.count - 1 {
            sections.append(section)
        } else {
            sections[sectionIdx] = section
        }
        self.source = .init(sections: sections)
        self.dataSource = source
        self.delegate = source
        self.prefetchDataSource = source
        performBatchUpdates {
            self.reloadSections(.init(integer: sectionIdx))
        }
    }
    
    func insertSection(_ section: CollectionSection, at sectionIdx: Int) {
        var sections = self.source?.sections ?? []
        if sectionIdx > sections.count - 1 {
            sections.append(section)
        } else {
            sections.insert(section, at: sectionIdx)
        }
        self.source = .init(sections: sections)
        self.dataSource = self.source
        self.delegate = self.source
        self.prefetchDataSource = source
        performBatchUpdates {
            self.reloadData()
        }
    }
    
    func deleteSection(at: Int) {
        var sections = self.source?.sections ?? []
        if at > sections.count {
            print("(ERROR) Invalid section to delete: \(at) with total: \(sections.count)")
            return
        } else {
            sections.remove(at: at)
            
            self.source = .init(sections: sections)
            self.dataSource = self.source
            self.delegate = self.source
            self.prefetchDataSource = source
            performBatchUpdates {
                self.reloadData()
            }
        }
        
    }
    
    func buildLayout(completion: @escaping Callback){
        let layout = UICollectionViewCompositionalLayout { idx, layoutEnv in
            self.source?.sections[idx].layout
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        config.boundarySupplementaryItems = (source?.headers ?? []) + (source?.footer ?? [])
        
        self.setCollectionViewLayout(layout, animated: false) { isFinished in
            if isFinished {
                completion()
            }
        }
    }
}
