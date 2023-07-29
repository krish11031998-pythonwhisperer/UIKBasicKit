//
//  MatchGeometry.swift
//  MPC
//
//  Created by Krishna Venkatramani on 29/06/2023.
//

import Foundation
import UIKit

public protocol MatchedGeometryView: UIViewController {
    func hideChildViews(withAnimation: Bool, withDuration duration: TimeInterval)
    func unhideChildViews(withAnimation: Bool, withDuration duration: TimeInterval)
    func matchedViewToTransitionFrom() -> UIView
}

public class MatchedGeometryPresentation: UIPresentationController {
    
    private let initialFrame: CGRect
    private let finalFrame: CGRect
    
    private var matchedGeometryView: MatchedGeometryView? { presentedViewController as? MatchedGeometryView }
    private lazy var matchingCopyView: UIView? = { matchedGeometryView?.matchedViewToTransitionFrom() }()
    private lazy var dimmingView: UIView = { .init() }()
    
    init(from: UIViewController?, to: UIViewController, initialFrame: CGRect, finalFrame: CGRect) {
        self.initialFrame = initialFrame
        self.finalFrame = finalFrame
        super.init(presentedViewController: to, presenting: from)
        //addTapToDismiss()
    }
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        finalFrame
    }
    
    public override func presentationTransitionWillBegin() {
        guard let containerView, let presentedView else { return }
        matchedGeometryView?.hideChildViews(withAnimation: false, withDuration: 0)
        
        containerView.addSubview(dimmingView)
        dimmingView.fillSuperview()
        dimmingView.alpha = 0
        dimmingView.backgroundColor = .black
        
        containerView.addSubview(presentedView)
        presentedView.layoutIfNeeded()
        presentedView.frame = initialFrame
        
        
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.matchedGeometryView?.unhideChildViews(withAnimation: true, withDuration: 1)
            self?.dimmingView.alpha = 0.5
        })
    }
    
    public override func dismissalTransitionWillBegin() {
       presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
           guard let self else { return }
           self.matchedGeometryView?.hideChildViews(withAnimation: true, withDuration: 1)
       })
    }
    
    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        guard completed else { return }
        presentedView?.animate(.fadeOut(duration: 0.3)) { [weak presentedView] in
            presentedView?.removeFromSuperview()
        }
        
    }
}
    

extension MatchedGeometryPresentation: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        self
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self
    }
}

extension MatchedGeometryPresentation: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let isPresented = presentedViewController.isBeingPresented
        print("(DEBUG) isPresented: ", isPresented)
        let vc = isPresented ? transitionContext.viewController(forKey: .to) : transitionContext.viewController(forKey: .from)
        let finalFrameOfView = isPresented ? finalFrame : initialFrame
        
        let springAnimation = UISpringTimingParameters(dampingRatio: 0.95, initialVelocity: .init(dx: 1, dy: 1))
        let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext),
                                              timingParameters: springAnimation)
        
        if isPresented {
            animator.addAnimations { [weak vc] in
                vc?.view.frame.origin = finalFrameOfView.origin
            }
            
            animator.addAnimations({ [weak vc] in
                vc?.view.frame.size = finalFrameOfView.size
                vc?.view.layoutIfNeeded()
            }, delayFactor: 0.2)
        } else {
            animator.addAnimations ({ [weak vc] in
                vc?.view.frame.origin = finalFrameOfView.origin
            }, delayFactor: 0.2)
            
            animator.addAnimations{ [weak vc] in
                vc?.view.frame.size = finalFrameOfView.size
                vc?.view.layoutIfNeeded()
            }
        }
        

        animator.addCompletion { [weak self] _ in
            if isPresented {
                self?.matchingCopyView?.removeFromSuperview()
            }
            transitionContext.completeTransition(true)
        }
        
        animator.startAnimation()
    }
}
