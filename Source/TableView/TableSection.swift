//
//  TableSection.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import Foundation
import UIKit
import Combine

//MARK: - TableSectionSupplementViewProvider
public protocol TableSectionSupplementaryViewProvider {
    var view: UIView { get }
}

//MARK: - TableSection
public struct TableSection {
	var rows:[TableCellProvider]
    var customHeader: TableSectionSupplementaryViewProvider?
	var customFooter: TableSectionSupplementaryViewProvider?
    
    public init(rows: [TableCellProvider],
         customHeader: TableSectionSupplementaryViewProvider? = nil,
         customFooter: TableSectionSupplementaryViewProvider? = nil) {
        self.rows = rows
        self.customHeader = customHeader
        self.customFooter = customFooter
    }
}

extension TableSection: Equatable {
    public static func == (lhs: TableSection, rhs: TableSection) -> Bool {
        lhs.rows.count == rhs.rows.count
    }
}

//MARK: - TableSection + Array
public extension Array where Self.Element == TableSection {
    
    static func + (lhs: [Self.Element], rhs: [Self.Element]) -> [Self.Element] {
        var result: [TableSection] = lhs
        result.append(contentsOf: rhs)
        return result
    }
    
}
