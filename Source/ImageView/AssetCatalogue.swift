//
//  AssetCatalogue.swift
//  Pods-UIKBasicKit_Example
//
//  Created by Krishna Venkatramani on 22/07/2023.
//

import Foundation

public protocol AssetCatalogue {
    var image: UIImage { get }
    func image(withTint color: UIColor) -> UIImage
}

public extension AssetCatalogue {
    func image(withTint color: UIColor) -> UIImage {
        image.withTintColor(color)
    }
}
