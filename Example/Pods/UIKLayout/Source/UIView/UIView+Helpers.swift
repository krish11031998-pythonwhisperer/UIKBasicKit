//
//  UIView+Helpers.swift
//  UIKLayout
//
//  Created by Krishna Venkatramani on 13/07/2023.
//

import UIKit

//MARK: - UIView+Helpers
public extension UIView {
    
    var userInterface: UIUserInterfaceStyle { traitCollection.userInterfaceStyle }
    
    var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    func cornerRadius(_ value: CGFloat, at corners: CornerRadius) {
        cornerRadius = value
        layer.maskedCorners = corners.corners
    }
    
    var clippedCornerRadius: CGFloat {
        get { cornerRadius }
        set {
            clipsToBounds = true
            cornerRadius = newValue
        }
    }
    
    //func cornerRadius(

    var compressedSize: CGSize {
        systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    func setCompressedSize() {
        let size = compressedSize
        setFrame(width: size.width, height: size.height)
    }

    //MARK: - Circular
    
    var circleFrame: CGRect {
        get { bounds }
        set {
            frame = newValue
            cornerRadius = min(newValue.width, newValue.height) * 0.5
            clipsToBounds = true
        }
    }
    
    convenience init(circular: CGRect, background: UIColor) {
        self.init()
        circleFrame = circular
        backgroundColor = background
        clipsToBounds = true
    }
}

