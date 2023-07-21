//
//  TableRow.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import Foundation
import UIKit

public typealias ConfigurableCell = Configurable & UITableViewCell

public protocol TableCellProvider {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	func tableView(_ tableView: UITableView, updateRowAt indexPath: IndexPath)
	func didSelect(_ tableView: UITableView, indexPath: IndexPath)
}

public extension Array where Self.Element == TableCellProvider {
    
    static func + (lhs: [Self.Element], rhs: [Self.Element]) -> [Self.Element] {
        var result: [Self.Element] = lhs
        result.append(contentsOf: rhs)
        return result
    }
}

public class TableRow<Cell: ConfigurableCell>: TableCellProvider {
	
	var model: Cell.Model
	
	public init(_ model: Cell.Model) {
		self.model = model
	}
	
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: Cell = tableView.dequeueCell(indexPath: indexPath)
		cell.configure(with: model)
		return cell
	}
	
    public func tableView(_ tableView: UITableView, updateRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as? Cell
		cell?.configure(with: model)
	}
	
    public func didSelect(_ tableView: UITableView, indexPath: IndexPath) {
        guard let provider = model as? ActionProvider else { return }
        
        if let action = provider.action {
			action()
        } else if let cellAction = provider.actionWithTableView, let cell = tableView.cellForRow(at: indexPath) {
            cellAction(cell, tableView)
        }
	}
	
}

