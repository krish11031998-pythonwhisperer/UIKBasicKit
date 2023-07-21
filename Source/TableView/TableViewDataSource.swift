//
//  TableViewDataSoruce.swift
//  Dekrypt
//
//  Created by Krishna Venkatramani on 31/03/2023.
//

import Foundation
import UIKit

public class TableViewDataSource: NSObject {
    
    public var sections: [TableSection]
    
    public init(sections: [TableSection]) {
        self.sections = sections
    }

    public lazy var indexPaths: [IndexPath] = {
        var paths = [IndexPath]()
        sections.enumerated().forEach { section in
            section.element.rows.enumerated().forEach { row in
                paths.append(.init(row: row.offset, section: section.offset))
            }
        }
        
        return paths
    }()
}


extension TableViewDataSource: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int { sections.count }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { sections[section].rows.count }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        sections[indexPath.section].rows[indexPath.row].tableView(tableView, cellForRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, updateRowAt indexPath: IndexPath) {
        sections[indexPath.section].rows[indexPath.row].tableView(tableView, updateRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = sections[indexPath.section].rows[indexPath.row]
        row.didSelect(tableView, indexPath: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        sections[section].customHeader?.view
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sections[section].customFooter?.view
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        sections[section].customHeader?.view == nil ? 10 : UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        sections[section].customFooter?.view == nil ? 10 : UITableView.automaticDimension
    }
}
