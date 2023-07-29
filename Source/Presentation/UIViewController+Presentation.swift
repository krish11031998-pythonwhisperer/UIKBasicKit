//
//  UIViewController+Presentation.swift
//  Dekrypt
//
//  Created by Krishna Venkatramani on 18/01/2023.
//

import Foundation
import UIKit

public extension UIViewController {
    
    var preferredContentHeight: CGFloat {
        guard preferredContentSize.height == 0 else { return preferredContentSize.height }
        return calculateHeight()
    }
    
    func calculateHeight() -> CGFloat {
        let topInset = self.navBarHeight
        
        if let scrollView = view as? UIScrollView {
            return scrollView.contentSize.height + scrollView.contentInset.top + scrollView.contentInset.bottom + topInset
        }
            
        var height = view.compressedSize.height + topInset
            
        //MARK: - ScrollView
        let scrollViews = view.subviews.compactMap { $0 as? UIScrollView }
        
        height += scrollViews.reduce(CGFloat(0), { result, scrollView in
            if scrollView.intrinsicContentSize.height <= 0 {
                return result + scrollView.contentSize.height + scrollView.contentInset.top + scrollView.contentInset.bottom
            } else {
                return result
            }
        })
        
        
    
        return height
    }
    
    //MARK: Dismiss Top VC
    func dismissTopMostAndNavigate(animation: Bool = false,
                                   completion: Callback? = nil) {
        guard let presentedViewController = presentedViewController else {
            completion?()
            return
        }
        presentedViewController.dismiss(animated: animation,
                                        completion: completion)
        
    }
}
