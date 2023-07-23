//
//  UIView+Gesture.swift
//  Dekrypt
//
//  Created by Krishna Venkatramani on 09/02/2023.
//

import Foundation
import UIKit

//MARK: - UIView+TapGesture
public extension UIView {
    private static var tapGesturePropertyKey: UInt8 = 0
    private var tapGestureHandler: Callback? {
        get { objc_getAssociatedObject(self, &Self.tapGesturePropertyKey) as? Callback }
        set { objc_setAssociatedObject(self, &Self.tapGesturePropertyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    
    func tapGesture(numberOfTouches: Int = 1, cancelsTouchesInView: Bool = false, handler: @escaping Callback) {
        tapGestureHandler = handler
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizerHandler))
        self.isUserInteractionEnabled = true
        tapGesture.numberOfTapsRequired = numberOfTouches
        tapGesture.cancelsTouchesInView = cancelsTouchesInView
        addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func tapGestureRecognizerHandler() {
        tapGestureHandler?()
    }
    
}


//MARK: - UIView+SwipeGesture
public extension UIView {
    private static var swipeGesturePropertyKey: UInt8 = 0
    private var swipeGestureHandler: Callback? {
        get { objc_getAssociatedObject(self, &Self.swipeGesturePropertyKey) as? Callback }
        set { objc_setAssociatedObject(self, &Self.swipeGesturePropertyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    
    func swipeGesture(direction: UISwipeGestureRecognizer.Direction,
                      cancelsTouchesInView: Bool = false,
                      handler: @escaping Callback) {
        swipeGestureHandler = handler
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureRecognizerHandler))
        self.isUserInteractionEnabled = true
        swipe.direction = direction
        swipe.cancelsTouchesInView = cancelsTouchesInView
        addGestureRecognizer(swipe)
    }
    
    @objc
    private func swipeGestureRecognizerHandler() {
        swipeGestureHandler?()
    }
    
}
