//
//  UIView+Styling.swift
//  CountdownTimer
//
//  Created by Krishna Venkatramani on 20/09/2022.
//

import Foundation
import UIKit

//MARK: - Corners
public enum CornerRadius {
    case top
    case bottom
    case all
    
    var corners: CACornerMask {
        switch self {
        case .top: return [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        case .bottom: return [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        case .all: return [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        }
    }
}


//MARK: - UIView+Styling
public extension UIView {
    func border(color: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat? = nil) {
        layer.borderColor = color.cgColor
        layer.borderWidth = borderWidth
        
        if let validCornerRadius = cornerRadius {
            self.cornerRadius = validCornerRadius
        }
    }
    
    var defaultBlurStyle: UIBlurEffect.Style {
        userInterface == .light ? .systemThinMaterialLight : .systemUltraThinMaterialDark
    }
    
    func addBlurView(_ _style: UIBlurEffect.Style? = nil) {
        let style = _style ?? defaultBlurStyle
        let blur = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blur)
        addSubview(blurView)
        setFittingConstraints(childView: blurView, insets: .zero)
        sendSubviewToBack(blurView)
    }
    
    func addShadow(color: UIColor = .white){
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = userInterface == .dark ? 0.2 : 0.2
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 2
    }
    
    func add3DShadow(size: CGSize = .init(width: 1, height: 1),
                     color: UIColor = .black,
                     opacity: Float = 1,
                     radius: CGFloat = 0) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = size
        self.layer.shadowRadius = radius
    }
    
    func addShadowBackground(inset: UIEdgeInsets = .zero, cornerRadius: CGFloat = 8) {
        let view = UIView()
        view.addShadow()
        view.border(color: .clear, borderWidth: 1, cornerRadius: cornerRadius)
        addSubview(view)
        sendSubviewToBack(view)
        setFittingConstraints(childView: view, insets: inset)
    }
}


