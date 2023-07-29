//
//  UIViewController.swift
//  UIKBasicKit
//
//  Created by Krishna Venkatramani on 27/07/2023.
//

import Foundation
import UIKit


//MARK: - UIViewController Presentation
public extension UIViewController {
    
    func presentView(style: PresentationStyle, addDimmingView: Bool = true, target: UIViewController, onDimissal: Callback?) {
        let presenter = PresentationController(style: style,
                                               addDimmingView: addDimmingView,
                                               presentedViewController: target,
                                               presentingViewController: self,
                                               onDismiss: onDimissal)
        target.transitioningDelegate = presenter
        target.modalPresentationStyle = .custom
        presentFromVC(vc: target)
    }
    
    func presentMatchGeometry(frame: CGRect, target: UIViewController) {
        let presenter = MatchedGeometryPresentation(from: self, to: target, initialFrame: frame, finalFrame: CGSize.totalScreenSize.bounds)
        target.transitioningDelegate = presenter
        target.modalPresentationStyle = .custom
        presentFromVC(vc: target)
    }
    
    func presentFromVC(vc: UIViewController, animated: Bool = true, completion: Callback? = nil) {
        let from = navigationController ?? self
        dismissTopMostAndNavigate(animation: animated) { [weak from] in
            from?.present(vc, animated: animated, completion: completion)
        }
        
    }
    
}
