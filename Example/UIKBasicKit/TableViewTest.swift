//
//  TableViewTest.swift
//  UIKBasicKit_Example
//
//  Created by Krishna Venkatramani on 21/07/2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import UIKBasicKit

class TableViewTest: UIViewController {
    
    private lazy var tableView: UITableView = { .init() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        tableView.reloadData(.init(sections: [tableDataSource()]))
    }
    
    private func setupView(){
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    private func tableDataSource() -> TableSection {
        let cells = Array(0...10).map { TableRow<BasicTableCell>(.init(model: $0)) }
        return .init(rows: cells)
    }

}
