//
//  UIStackView.swift
//  UIKBasicKit
//
//  Created by Krishna Venkatramani on 22/07/2023.
//

import Foundation
import UIKit

//MARK: - UIView
public extension UIView {

    static func HStack(subViews: [UIView] = [], spacing: CGFloat,
                       alignment: UIStackView.Alignment = .fill,
                       insetFromSafeArea: Bool = true) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: subViews)
        stack.spacing = spacing
        stack.alignment = alignment
        stack.insetsLayoutMarginsFromSafeArea = insetFromSafeArea
        return stack
    }
    
    static func VStack(subViews: [UIView] = [], spacing: CGFloat,
                       alignment: UIStackView.Alignment = .fill,
                       insetFromSafeArea: Bool = true) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: subViews)
        stack.axis = .vertical
        stack.spacing = spacing
        stack.alignment = alignment
        stack.insetsLayoutMarginsFromSafeArea = insetFromSafeArea
        return stack
    }
    
    static func flexibleStack(subViews: [UIView], width: CGFloat = .totalWidth) -> UIStackView {
        let mainStack: UIStackView = .VStack(spacing: 8, alignment: .leading)
        
        subViews.sizeFittingStack(for: width, with: 8).forEach { row in
            let rowStack = UIView.HStack(subViews: row, spacing: 8)
            mainStack.addArrangedSubview(rowStack)
        }
        
        return mainStack
    }
    
    static func emptyViewWithColor(color: UIColor = .clear, width: CGFloat? = nil, height: CGFloat? = nil) ->  UIView {
        let blankView = UIView()
        blankView.backgroundColor = .clear
        if let validHeight = height {
            blankView.setHeight(height: validHeight, priority: .required)
        }
        
        if let validWidth = width {
            blankView.setWidth(width: validWidth, priority: .required)
        }
        
        return blankView
    }
    
    static func solidColorView(frame: CGRect, backgroundColor: UIColor) -> UIView {
        let view = UIView(frame: frame)
        view.backgroundColor = backgroundColor
        return view
    }
    
    func firstSubviewOf<T:UIView>() -> T? { subviews.first as? T }
}
