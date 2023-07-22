//
//  BasicHeader.swift
//  UIKBasicKit_Example
//
//  Created by Krishna Venkatramani on 21/07/2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import UIKBasicKit

class BasicHeader: ConfigurableCollectionSV {
    
    public static var cellName: String? { Self.name }
    
    private lazy var header: UILabel = { .init() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .red
        addSubview(header)
        header
            .pinCenterXAnchorTo(constant: 0)
            .pinCenterYAnchorTo(constant: 0)
    }
    
    public func configure(with model: String) {
        model.styled(.boldSystemFont(ofSize: 24), color: .white).render(target: header)
    }
}
