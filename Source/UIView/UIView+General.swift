//
//  Views.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit

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
