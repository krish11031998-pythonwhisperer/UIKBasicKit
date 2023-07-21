//
//  CustomFonts.swift
//  UIKLayout
//
//  Created by Krishna Venkatramani on 13/07/2023.
//

import Foundation

public protocol CustomFonts {
    var name: String { get }
    func fontBuilder(size: CGFloat) -> UIFont?
}

public extension CustomFonts {
    func fontBuilder(size: CGFloat) -> UIFont? {
        .init(name: name, size: size)
    }
}
