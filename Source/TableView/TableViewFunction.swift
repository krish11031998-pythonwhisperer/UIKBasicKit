//
//  TableViewFunction.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import Foundation
import UIKit

public extension NSObject {
	
	static var name: String { "\(self)" }
}

fileprivate extension Array where Self.Element : Equatable {
    
    func findIdx(_ el: Self.Element) -> Int? {
        guard let first = self.enumerated().filter({ $0.element == el }).first else { return nil }
        return first.offset
    }
}

public extension UITableView {
	
	private static var propertyKey: UInt8 = 1
	
	private var source: TableViewDataSource? {
		get { return objc_getAssociatedObject(self, &Self.propertyKey) as? TableViewDataSource }
		set { objc_setAssociatedObject(self, &Self.propertyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
	}
	
	func registerCell(cell: AnyClass, identifier: String) {
		register(cell, forCellReuseIdentifier: identifier)
	}
	
    func dequeueCell<T: ConfigurableCell>(cellIdentifier: String = T.cellName ?? T.name, indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellIdentifier) as? T else {
			registerCell(cell: T.self, identifier: cellIdentifier)
			return dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? T ?? T()
		}
		
		return cell
	}
	
	
	func reloadData(_ dataSource: TableViewDataSource, lazyLoad: Bool = false, animation: UITableView.RowAnimation = .none) {
		self.source = dataSource
		
		self.dataSource = dataSource
		self.delegate = dataSource
		
		if let paths = indexPathsForVisibleRows, lazyLoad, dataSource.indexPaths == paths {
			if animation != .none {
				reloadRows(at: paths, with: animation)
			} else {
				paths.forEach { dataSource.tableView(self, updateRowAt: $0) }
			}
		} else {
			reloadData()
		}
	}
    
    //MARK: -  Must Deprecate!
    func reloadRows(_ dataSource: TableViewDataSource, section: Int) {
        self.source = dataSource
        self.dataSource = dataSource
        self.delegate = dataSource
        
        let currentRows = numberOfRows(inSection: section)
        let newRows = dataSource.tableView(self, numberOfRowsInSection: section)
    
        guard currentRows < newRows else {
            replaceRows(rows: dataSource.sections[section].rows, section: section)
            return
        }
        let newIndexPath: [IndexPath] = (currentRows..<newRows).map { .init(row: $0, section: section) }
        
        UIView.performWithoutAnimation {
            beginUpdates()
            insertRows(at: newIndexPath, with: .left)
            endUpdates()
        }
    }
    
    func replaceRows(rows:[TableCellProvider],
                     section: Int,
                     replaceOffset: Int = 0,
                     insertAnimation: UITableView.RowAnimation = .fade,
                     deleteRowAnimation:UITableView.RowAnimation = .fade)
    {
        let newSource = self.source
        newSource?.sections[section].rows = rows
        
        self.source = newSource
        self.dataSource = newSource
        self.delegate = newSource
        
        let currentRows = (replaceOffset..<numberOfRows(inSection: section)).map { IndexPath(row: $0, section: section) }
        let newRows = (replaceOffset..<(source?.tableView(self, numberOfRowsInSection: section) ?? 1)).map { IndexPath(row: $0, section: section) }
        let offset = self.contentOffset
        
        beginUpdates()
        deleteRows(at: currentRows, with: deleteRowAnimation)
        insertRows(at: newRows, with: insertAnimation)
        setContentOffset(offset, animated: false)
        endUpdates()
    }
	
    func insertSection(_ section: TableSection, at sectionIdx: Int? = nil) {
        var sections = self.source?.sections ?? []
        let idx = sectionIdx ?? sections.count
        sections.append(section)
        self.source = .init(sections: sections)
        self.dataSource = source
        self.delegate = source
        beginUpdates()
        insertSections([idx], with: .fade)
        endUpdates()
    }
    
    func reloadSection(_ section: TableSection, at sectionIdx: Int, animation: UITableView.RowAnimation = .none) {
        var sections = self.source?.sections ?? []
        if sectionIdx > sections.count - 1 {
            sections.append(section)
        } else {
            sections[sectionIdx] = section
        }
        self.source = .init(sections: sections)
        self.dataSource = source
        self.delegate = source
        performBatchUpdates {
            self.reloadSections([sectionIdx], with: animation)
        }
    }
    
    func showTableSection(section: Int) {
        (0..<numberOfRows(inSection: section))
            .forEach {
                let cell = self.cellForRow(at: IndexPath(row: $0, section: section))
                cell?.alpha = 1
            }
    }
    
    func hideTableSection(section: Int, rowOffset: Int = 0) {
        (rowOffset..<numberOfRows(inSection: section))
            .forEach {
                let cell = self.cellForRow(at: IndexPath(row: $0, section: section))
                cell?.alpha = 0
            }
    }
    
    func hideAllTableSection() {
        for section in 0..<numberOfSections {
            let header = headerView(forSection: section)
            UIView.animate(withDuration: 0.3, delay: 0) { [weak header] in
                header?.alpha = 0
            }
            (0..<numberOfRows(inSection: section))
                .forEach {
                    let cell = self.cellForRow(at: IndexPath(row: $0, section: section))
                    cell?.alpha = 0
                }
        }
    }
    
    func showAllTableSection() {
        for section in 0..<numberOfSections {
            let header = headerView(forSection: section)
            UIView.animate(withDuration: 0.3, delay: 0) { [weak header] in
                header?.alpha = 1
            }
            (0..<numberOfRows(inSection: section))
                .forEach {
                    let cell = self.cellForRow(at: IndexPath(row: $0, section: section))
                    cell?.alpha = 1
                }
        }
    }
}
