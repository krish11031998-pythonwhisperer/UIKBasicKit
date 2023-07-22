//
//  ColorProtocol.swift
//  Pods-UIKLayout_Example
//
//  Created by Krishna Venkatramani on 13/07/2023.
//

import UIKit

public protocol AppColorCatalogue where Self: UIColor {
    static var surfaceBackground: UIColor { get }
    static var surfaceBackgroundInverse: UIColor { get }
    static var textColor: UIColor { get }
    static var textColorInverse: UIColor { get }
}
