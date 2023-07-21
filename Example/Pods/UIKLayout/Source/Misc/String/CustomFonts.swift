//
//  CustomFonts.swift
//  UIKLayout
//
//  Created by Krishna Venkatramani on 13/07/2023.
//

import Foundation

public protocol CustomFontType {
    var name: String { get }
    func fontBuilder(size: CGFloat) -> UIFont?
}

public extension CustomFontType {
    func fontBuilder(size: CGFloat) -> UIFont? {
        .init(name: name, size: size)
    }
}
