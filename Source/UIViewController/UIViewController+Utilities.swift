//
//  UIViewController+Utilities.swift
//  UIKBasicKit
//
//  Created by Krishna Venkatramani on 27/07/2023.
//

import Foundation
import UIKit

public extension UIViewController {
    private static var animatingPropertyKey: UInt8 = 1

    var isTopMostController: Bool {
        guard let nav = navigationController else { return false }
        return nav.viewControllers.count == 1 && nav.topViewController === self
    }
        
    var compressedSize : CGSize {
        let height = view.compressedSize.height.boundTo(lower: 200, higher: .totalHeight) - (view.safeAreaInsets.top + view.safeAreaInsets.bottom)
        let size: CGSize = .init(width: .totalWidth, height: height)
        return size
    }
    
    func setupTransparentNavBar(color: UIColor = .clear, scrollColor: UIColor = .clear) {
        let navbarAppear: UINavigationBarAppearance = .init()
        navbarAppear.configureWithTransparentBackground()
        navbarAppear.backgroundImage = UIImage()
        navbarAppear.backgroundColor = color
        
        self.navigationController?.navigationBar.standardAppearance = navbarAppear
        self.navigationController?.navigationBar.compactAppearance = navbarAppear
        self.navigationController?.navigationBar.scrollEdgeAppearance = navbarAppear
        //self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = scrollColor
    }
    
    func showNavbar(animated: Bool = true) {
        guard let navController = navigationController else { return }
        if navController.isNavigationBarHidden {
            navController.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    func hideNavbar(animated: Bool = true) {
        guard let navController = navigationController else { return }
        if !navController.isNavigationBarHidden {
            navController.setNavigationBarHidden(true, animated: animated)
        }
    }
    
    func showTab() {
        guard let tabBar = navigationController?.tabBarController?.tabBar else { return }
        if tabBar.hide {
            tabBar.hide = false
        }
    }
    
    func hideTab() {
        guard let tabBar = navigationController?.tabBarController?.tabBar else { return }
        if !tabBar.hide {
            tabBar.hide = true
        }
    }
    
    func withNavigationController(swipable: Bool = false) -> UINavigationController {
        guard let navVC = self as? UINavigationController else {
            if swipable {
                return SwipeableNavigationController(rootViewController: self)
            } else {
                return .init(rootViewController: self)
            }
        }
        return navVC
    }
    
    var navBarHeight: CGFloat {
        (navigationController?.navigationBar.frame.height ?? 0) + (navigationController?.additionalSafeAreaInsets.top ?? 0) +
        (navigationController?.additionalSafeAreaInsets.bottom ?? 0)
    }
    
    var navBarMaxY: CGFloat {
        (navigationController?.navigationBar.frame.minY ?? 0) + navBarHeight
    }
    
    func pushTo(target: UIViewController, asSheet: Bool = false) {
        dismissTopMostAndNavigate(animation: true) { [weak self] in
            guard let self else { return }
            if let nav = self.navigationController, !asSheet {
                nav.pushViewController(target, animated: true)
            } else {
                self.presentView(style: .sheet(), target: target.withNavigationController(), onDimissal: nil)
            }
        }
        
    }
}
