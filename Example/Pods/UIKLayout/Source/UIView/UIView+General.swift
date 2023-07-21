//
//  Views.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit

//MARK: - UIView
public extension UIView {

	static func HStack(subViews: [UIView] = [], spacing: CGFloat, alignment: UIStackView.Alignment = .fill) -> UIStackView {
		let stack = UIStackView(arrangedSubviews: subViews)
		stack.spacing = spacing
		stack.alignment = alignment
		return stack
	}
	
	static func VStack(subViews: [UIView] = [], spacing: CGFloat, alignment: UIStackView.Alignment = .fill) -> UIStackView {
		let stack = UIStackView(arrangedSubviews: subViews)
		stack.axis = .vertical
		stack.spacing = spacing
		stack.alignment = alignment
		return stack
	}
	
    static func flexibleStack(subViews: [UIView], width: CGFloat = UIScreen.main.bounds.width) -> UIStackView {
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
}

//MARK: - UIView+Gradients

public enum GradientDirection {
    case up, down, left, right, acrossLeftToRight, acrossRightToLeft
}

public extension UIView {
    func gradient(color: [UIColor], type: CAGradientLayerType = .axial, direction: GradientDirection) -> CALayer {
        let gradient: CAGradientLayer = .init()
        gradient.colors = color.compactMap { $0.cgColor }
        gradient.frame = bounds
        gradient.startPoint = .zero
        switch direction {
        case .up:
            gradient.startPoint = .init(x: 0, y: 1)
            gradient.endPoint = .init(x: 0, y: 0)
        case .down:
            gradient.startPoint = .init(x: 0, y: 0)
            gradient.endPoint = .init(x: 0, y: 1)
        case .left:
            gradient.startPoint = .init(x: 0, y: 0)
            gradient.endPoint = .init(x: 1, y: 0)
        case .right:
            gradient.startPoint = .init(x: 1, y: 0)
            gradient.endPoint = .init(x: 0, y: 0)
        case .acrossLeftToRight:
            gradient.startPoint = .zero
            gradient.endPoint = .init(x: 1, y: 1)
        case .acrossRightToLeft:
            gradient.startPoint = .init(x: 1, y: 1)
            gradient.endPoint = .zero
        }
        gradient.type = type
        return gradient
    }
}


//MARK: - UIView Modifiers
public extension UIView {
    func hideChildViews() {
        var views: [UIView] = subviews
        switch self {
        case let stack as UIStackView:
            views = stack.arrangedSubviews
        default: break
        }
        views.forEach { $0.isHidden = true }
    }
}
