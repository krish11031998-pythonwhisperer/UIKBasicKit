//
//  ConfigurableCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import Foundation
import UIKit

public typealias Callback = () -> Void
public typealias TableCellCallback = (UITableViewCell, UITableView) -> Void

public protocol Configurable {
	associatedtype Model
	func configure(with model: Model)
    static var cellName: String? { get }
    static func prefetch(with model: Model)
    static func cancelPrefetch(with model: Model)
}

public extension Configurable {
    static var cellName: String? { nil }
    static func prefetch(with model: Model) {}
    static func cancelPrefetch(with model: Model) {}
}

//MARK: - ActionProvider
public protocol ActionProvider {
	var action: Callback? { get }
    var actionWithFrame: ((CGRect) -> Void)? { get }
    var actionWithTableView: TableCellCallback? { get }
    var bounceOnClick: Bool { get }
}

public extension ActionProvider {
    var actionWithFrame: ((CGRect) -> Void)? { nil }
    var actionWithTableView: TableCellCallback? { nil }
    var bounceOnClick: Bool { true }
}
