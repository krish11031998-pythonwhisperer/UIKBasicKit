//
//  UIEdgeInsets.swift
//  CountdownTimer
//
//  Created by Krishna Venkatramani on 19/09/2022.
//

import Foundation
import UIKit

public extension UIEdgeInsets {
	
	init(by: CGFloat) {
		self.init(top: by, left: by, bottom: by, right: by)
	}
	
	init(vertical: CGFloat, horizontal: CGFloat) {
		self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
	}
    
    static var appInsets: UIEdgeInsets {
        return .init(vertical: .appVerticalPadding, horizontal: .appHorizontalPadding)
    }
    
    static var headerInsets: UIEdgeInsets {
        return .init(top: .appVerticalPadding,
                     left: .appHorizontalPadding,
                     bottom: 7.5,
                     right: .appHorizontalPadding)
    }
}

//MARK: - UIEdgeInset Constants
public extension UIEdgeInsets {
    
    static let tweetCellInsets: UIEdgeInsets = .init(by: 15)
}

//MARK: - NSDirectionEdgeInsets
public extension NSDirectionalEdgeInsets {
    
    init(by: CGFloat) {
        self.init(top: by, leading: by, bottom: by, trailing: by)
    }
    
    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
    
    static var appInsets: NSDirectionalEdgeInsets {
        return .init(vertical: 10, horizontal: .appHorizontalPadding)
    }
    
    static var headerInsets: NSDirectionalEdgeInsets {
        return .init(top: .appVerticalPadding,
                     leading: .appHorizontalPadding,
                     bottom: 7.5,
                     trailing: .appHorizontalPadding)
    }
}
