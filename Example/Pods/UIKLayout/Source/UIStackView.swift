//
//  UIStackView.swift
//  UIKLayout
//
//  Created by Krishna Venkatramani on 13/07/2023.
//

import UIKit

public extension UIStackView {
    
    func insertAndReplaceArrangedSubview(_ view: UIView, at index: Int) {
        if index > arrangedSubviews.count - 1 {
            addArrangedSubview(view)
        } else {
            let presentView = arrangedSubviews[index]
            presentView.removeFromSuperview()
            insertArrangedSubview(view, at: index)
        }
    }
    
    func addInsets(insets: UIEdgeInsets) {
        isLayoutMarginsRelativeArrangement = true
        directionalLayoutMargins = .init(top: insets.top, leading: insets.left, bottom: insets.bottom, trailing: insets.right)
    }
    
    func flipStack() {
        let views = self.arrangedSubviews
        views.reversed()
            .addToView(self, removeChildren: true)
    }
}
