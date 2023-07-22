//
//  CollectionCellBuilder.swift
//  Dekrypt
//
//  Created by Krishna Venkatramani on 01/04/2023.
//

import Foundation
import UIKit

public class CollectionCellBuilder<T: ConfigurableViewElement>: ConfigurableCollectionCell {
    
    public struct CellModel: ActionProvider {
        let model: T.Model
        public var action: Callback?
        
        public init(model: T.Model, action: Callback? = nil) {
            self.model = model
            self.action = action
        }
    }
    
    private lazy var content: T = { .init() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(content)
        contentView.setFittingConstraints(childView: content, insets: .zero)
        backgroundColor = .clear//.surfaceBackground
    }
    
    public func configure(with model: CellModel) {
        content.configure(with: model.model)
    }
    
    public static var cellName: String? { T.name }
    
    public func willDisplay() {
    }
    
    public func endDisplay() {
    }
    
    public override func prepareForReuse() { content.prepareViewForReuse() }
    
}
