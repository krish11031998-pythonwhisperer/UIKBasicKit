//
//  ViewController.swift
//  UIKBasicKit
//
//  Created by 56647167 on 07/14/2023.
//  Copyright (c) 2023 56647167. All rights reserved.
//

import UIKit
import Combine
import UIKBasicKit

class ViewController: UIViewController {

    private lazy var tableView: UITableView = { .init() }()
    private lazy var stackView: UIStackView = { .VStack(spacing: 8) }()
    private var collectionButton: UIButton!
    private var tableButton: UIButton!
    private var presentationButton: UIButton!
    private var presentTable: UIButton!
    
    private var bag: Set<AnyCancellable> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupView()
        bind()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupView() {
        view.addSubview(stackView)
        stackView.fillSuperview(inset: .init(by: 32))
        
        stackView.insetsLayoutMarginsFromSafeArea = true
        
        collectionButton = buttonBuilder(title: "Collection")
        tableButton = buttonBuilder(title: "Table")
        presentationButton = buttonBuilder(title: "Presentation")
        presentTable = buttonBuilder(title: "Present Table")
        
        
        [.spacer(), presentTable, presentationButton, collectionButton, tableButton].addToView(stackView)
    }
    
    private func bind() {
        collectionButton
            .onTap { [weak self] in
                self?.navigationController?.pushViewController(CollectionViewTest(), animated: true)
            }
            .store(in: &bag)
        
        tableButton
            .onTap { [weak self] in
                self?.navigationController?.pushViewController(TableViewTest(), animated: true)
            }
            .store(in: &bag)
        
        presentationButton
            .onTap { [weak self] in
                self?.presentView(style: .dynamic, addDimmingView: true, target: MessageView(), onDimissal: nil)
            }
            .store(in: &bag)
        
        presentTable
            .onTap { [weak self] in
                let nav = UINavigationController(rootViewController: MessageTableView())
                
                self?.presentView(style: .dynamic, target: nav, onDimissal: nil)
            }
            .store(in: &bag)
    }
    
    private func buttonBuilder(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = .blue
        button.titleLabel?.textColor = .white
        button.setHeight(height: 44)
        return button
    }
}

fileprivate class MessageView: UIViewController {
    
    private lazy var label: DualLabel = { .init(spacing: 8, axis: .vertical, addSpacer: .none) }()
    private lazy var button: UIButton = { .init() }()
    private var bag: Bag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }
    
    private func setupView() {
        button.backgroundColor = .red
        button.setTitle("Ok", for: .normal)
        button.setHeight(height: 44)
        
        let stack = UIStackView.VStack(subViews: [label, button], spacing: 12, insetFromSafeArea: true)
        view.addSubview(stack)
        stack.fillSuperview(inset: .sheetInsets)
        
        label.configure(title: "Test".styled(.boldSystemFont(ofSize: 14), color: .black),
                        subtitle: "This is a test message".styled(.systemFont(ofSize: 12, weight: .regular), color: .black))
        
        view.backgroundColor = .white
    }
    
    private func bind() {
        button
            .onTap { [weak self] in
                self?.dismiss(animated: true)
            }
            .store(in: &bag)
    }
}


fileprivate class MessageTableView: UIViewController {
    
    private lazy var label: DualLabel = { .init(spacing: 8, axis: .vertical, addSpacer: .none) }()
    private lazy var tableView: UITableView = { .init(frame: .zero, style: .grouped) }()
    private lazy var button: UIButton = { .init() }()
    private var bag: Bag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadTable()
        bind()
    }
    
    private func setupView() {
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .red
        view.clipsToBounds = true
        view.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        
        //navigtionnavigationBar.isHidden = false
        navigationItem.leftBarButtonItem = .init(customView: "Table View".styled(.boldSystemFont(ofSize: 14), color: .black).generateLabel)
        navigationController?.additionalSafeAreaInsets.top = 12
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundImage = nil
        appearance.backgroundColor = .white
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func loadTable() {
        let cells: [TableCellProvider] = ["Cell One", "Cell Two", "Cell Third", "Cell One", "Cell Two", "Cell Third"]
            .map {
                return TableRow<TableCellBuilder<UILabel>>(.init(model: $0))
            }
        tableView.reloadData(.init(sections: [.init(rows: cells)]))
    }
    
    private func bind() {
        button
            .onTap { [weak self] in
                self?.dismiss(animated: true)
            }
            .store(in: &bag)
    }
}

extension UILabel: ConfigurableViewElement {
    public func configure(with model: String) {
        self.text = model
        self.font = .boldSystemFont(ofSize: 12)
    }
}
