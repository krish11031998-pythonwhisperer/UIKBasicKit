//
//  TableCellBuilder.swift
//  Dekrypt
//
//  Created by Krishna Venkatramani on 01/04/2023.
//

import Foundation
import UIKit

public protocol ConfigurableViewElement: UIView {
    associatedtype Model
    func configure(with model: Model)
    func prepareViewForReuse()
}

public extension ConfigurableViewElement {
    func prepareViewForReuse() { }
}

public class TableCellBuilder<T: ConfigurableViewElement>: ConfigurableCell {

    public struct CellModel: ActionProvider {
        let model: T.Model
        public var action: Callback?
        
        public init(model: T.Model, action: Callback? = nil) {
            self.model = model
            self.action = action
        }
    }
    
    private lazy var content: T = { .init() }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(content)
        contentView.setFittingConstraints(childView: content, insets: .appInsets)
        backgroundColor = .clear//.surfaceBackground
        selectionStyle = .none
    }
    
    public func configure(with model: CellModel) {
        content.configure(with: model.model)
    }
    
    public static var cellName: String? { T.name }
    
    public override func prepareForReuse() {
        content.prepareViewForReuse()
    }
}

