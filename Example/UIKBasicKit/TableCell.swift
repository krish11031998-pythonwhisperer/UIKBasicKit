//
//  TableCell.swift
//  UIKBasicKit_Example
//
//  Created by Krishna Venkatramani on 21/07/2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import UIKBasicKit
import Combine

extension UIImage {
    static func randomImages(idx: Int) -> ImageSource { .remote(url: "https://picsum.photos/200/300?random=\(idx)") }
}

class BasicTableCellView: UIView, ConfigurableViewElement {
    
    private lazy var imageView: UIImageView = { .init() }()
    private lazy var titleLabel: UILabel = { .init() }()
    private var imageCancellable: AnyCancellable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let stack = UIStackView.HStack(subViews: [imageView, titleLabel], spacing: 16, alignment: .center)
        addSubview(stack)
        stack.fillSuperview(inset: .init(by: 10))
        
        imageView.setFrame(.init(squared: 64))
        imageView.clippedCornerRadius = 32
    }
    
    func configure(with model: Int) {
        "Cell \(model)"
            .styled(.boldSystemFont(ofSize: 12), color: .red)
            .render(target: titleLabel)
        
        UIImage.randomImages(idx: model).render(on: imageView)
    }

}

typealias BasicTableCell = TableCellBuilder<BasicTableCellView>
