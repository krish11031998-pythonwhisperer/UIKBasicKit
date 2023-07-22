//
//  BasicCell.swift
//  UIKBasicKit_Example
//
//  Created by Krishna Venkatramani on 21/07/2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import UIKBasicKit

//MARK: - BasicCollectionCell
class BasicCollectionCellView: UIView, ConfigurableViewElement {
    
    private lazy var textLabel: UILabel = { .init() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(textLabel)
        textLabel.fillSuperview(inset: .init(vertical: 12, horizontal: 16))
    }
    
    func configure(with model: String) {
        model.styled(.boldSystemFont(ofSize: 12), color: .blue).render(target: textLabel)
    }
}

typealias BasicCollectionCell = CollectionCellBuilder<BasicCollectionCellView>


