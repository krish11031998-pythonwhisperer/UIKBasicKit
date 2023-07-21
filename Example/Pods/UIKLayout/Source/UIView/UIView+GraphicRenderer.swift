//
//  UIView+GraphicRenderer.swift
//  UIKLayout
//
//  Created by Krishna Venkatramani on 13/07/2023.
//

import UIKit

//MARK: - UIView+GraphicRenderer
public extension UIView {
    var snapshot:UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let img =  renderer.image { context in
            layer.render(in: context.cgContext)
        }
        return img
    }
}

