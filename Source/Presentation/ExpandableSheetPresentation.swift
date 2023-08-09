//
//  ExpandableSheetPresentation.swift
//  UIKBasicKit
//
//  Created by Krishna Venkatramani on 10/08/2023.
//

import Foundation
import UIKit
import Combine

protocol ExpandableSheet {
    var titleText: RenderableText { get }
    var closeButtonImage: ImageSource { get }
    var contentOffset: AnyPublisher<CGFloat, Never>? { get }
    func updateTopHeader(_ height: CGFloat)
}

extension ExpandableSheet {
    var contentOffset: AnyPublisher<CGFloat, Never>? { nil }
}

class ExpandableSheetPresentation: UIPresentationController {
    
    private var bag: Bag = .init()
    private var addedAnimations: Bool = false
    private var isExpanded: Bool { expandingAnimator.fractionComplete != 0 }
    
    private lazy var pullTab: UIView = {
        let tabArea = UIView()
        let pullTab = UIView()
        pullTab.setFrame(width: .totalWidth * 0.25,
                         height: Constants.tabHeight)
        pullTab.clippedCornerRadius = Constants.tabHeight.half
        pullTab.backgroundColor =  .gray.withAlphaComponent(0.6)
        tabArea.addSubview(pullTab)
        pullTab
            .pinTopAnchorTo(constant: 0)
            .pinBottomAnchorTo(constant: 0)
            .pinCenterXAnchorTo(constant: 0)
            .pinCenterYAnchorTo(constant: 0)
        return tabArea
    }()
    
    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.3)
        return view
    }()
    
    private lazy var titleLabel: UILabel = { .init() }()
    private lazy var closeButton: UIButton = { .init() }()
    
    var nestedViewController: UIViewController? {
        guard let navController = presentedViewController as? UINavigationController else { return presentedViewController }
        return navController.viewControllers.last
    }
    
    private let expandingAnimator: UIViewPropertyAnimator = {
        let cubicParams = UICubicTimingParameters(animationCurve: .easeInOut)
        let animator = UIViewPropertyAnimator(duration: 0.3, timingParameters: cubicParams)
        animator.pausesOnCompletion = true
        return animator
    }()
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let screenBounds = UIScreen.main.bounds
        let height = screenBounds.height * 0.5
        return .init(x: 0, y: screenBounds.height * 0.5, width: screenBounds.width, height: height)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        setupAnimator()
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView else { return }
        containerView.addSubview(dimmingView)
        dimmingView.frame = containerView.bounds
        dimmingView.alpha = 0
        dimmingView.tapGesture { [weak self] in
            self?.presentedViewController.dismiss(animated: true)
        }
        
        guard let presentedView else { return }
        containerView.addSubview(presentedView)
        presentedView.frame = frameOfPresentedViewInContainerView
        presentedView.frame.origin.y = UIScreen.main.bounds.height
        presentedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        presentedView.clippedCornerRadius = 12

        //MARK: Adding PullTab
        setupNavHeader()
        bind()
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.dimmingView.alpha = 1
        })
    }
    
    override func dismissalTransitionWillBegin() {
        expandingAnimator.stopAnimation(true)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.dimmingView.alpha = 0
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        guard completed else { return }
        dimmingView.removeFromSuperview()
    }
    
    private func setupAnimator() {
        guard !addedAnimations else { return }
        addAnimation()
        presentedView?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGesture)))
        addedAnimations.toggle()
    }
    
    private func addAnimation() {
        expandingAnimator.addAnimations { [weak self] in
            guard let self, let presentedView = self.presentedView else { return }
            var finalFrame = presentedView.frame
            finalFrame.origin.y -= Constants.height
            finalFrame.size.height += Constants.height
            print("(DEBUG) finalFrame: ", finalFrame)
            presentedView.frame = finalFrame
        }
    }
    
    @objc
    private func panGesture(_ sender: UIPanGestureRecognizer) {
        guard let view = presentedView else { return }
        let translation = sender.translation(in: view).y
        if !isExpanded && translation > 0 {
            self.presentedViewController.dismiss(animated: true)
        } else {
            expandingAnimation(translation, state: sender.state)
        }
    }
    
    private func expandingAnimation(_ translation: CGFloat, state: UIPanGestureRecognizer.State) {
        if expandingAnimator.isReversed {
            expandingAnimator.isReversed = false
        }
        switch state {
        case .began:
            break
        case .changed:
            let fraction = (0...Constants.height).percent(abs(translation)).boundTo(lower: 0, higher: 1)
            let fractionComplete = translation < 0 ? fraction : 1 - fraction
            self.expandingAnimator.fractionComplete = fractionComplete
        case .ended:
            let crossedThreshold: Bool = abs(translation) >= 50
            if crossedThreshold {
                if translation < 0 {
                    expandingAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                } else {
                    expandingAnimator.isReversed = true
                    expandingAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                }
            } else {
                if translation < 0 {
                    expandingAnimator.isReversed = true
                    expandingAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                } else {
                    expandingAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                }
            }
        default:
            break
        }
    }
    
    private func setupNavHeader() {
        closeButton.backgroundColor = .white
        closeButton.setFrame(.smallestSquare)
        closeButton.clippedCornerRadius = CGSize.smallestSquare.smallDim.half
        
        let headerStack = UIStackView.HStack(subViews: [titleLabel, .spacer(), closeButton], spacing: 8, alignment: .center)
        let stack = UIStackView.VStack(subViews: [pullTab, headerStack],
                                       spacing: 16,
                                       insetFromSafeArea: false)
        stack.addInsets(insets: .init(by: 16))
        
        guard let sheet = presentedViewController as? ExpandableSheet else {
            assertionFailure("(ERROR) presentedViewController needs to conform to ExpandableSheer")
            return
        }
        sheet.titleText.render(target: titleLabel)
        sheet.closeButtonImage.render(on: closeButton)
        presentedView?.addSubview(stack)
        stack.pinTopAnchorTo(constant: 0)
            .pinLeadingAnchorTo(constant: 0)
            .pinTrailingAnchorTo(constant: 0)
        stack.layoutIfNeeded()
        sheet.updateTopHeader(stack.frame.height)
    }
    
    private func bind() {
        closeButton
            .tapPublisher
            .unretainedSelf(self)
            .sinkReceive { (vc, _) in
                vc.presentedViewController.dismiss(animated: true)
            }
            .store(in: &bag)
        
        if let expandableVC = presentedViewController as? ExpandableSheet,
            let contentOff = expandableVC.contentOffset
        {
            contentOff
                .unretainedSelf(self)
                .sinkReceive { (vc, off) in
//                    vc.expandingAnimator.fractionComplete = (0...Constants.height).percent(off).boundTo()
                    UIView.animate(withDuration: 0.3) {
                        vc.presentedView?.transform = .init(translationX: 0, y: abs(off))
                    } completion: {
                        guard $0 else { return }
                        vc.presentedViewController.dismiss(animated: true)
                    }
                }
                .store(in: &bag)
            
        }
    }
}

extension ExpandableSheetPresentation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let isPresented = presentedViewController.isBeingPresented
        
        let key: UITransitionContextViewControllerKey = isPresented ? .to : .from
        
        guard let vc = transitionContext.viewController(forKey: key) else { return }
        
        var initialFrame = frameOfPresentedViewInContainerView
        initialFrame.origin.y = UIScreen.main.bounds.height
        
        vc.view.frame = isPresented ? initialFrame : frameOfPresentedViewInContainerView
        
        let propertyAnimator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), curve: .easeInOut)
        
        propertyAnimator.addAnimations {
            if isPresented {
                vc.view.frame.origin.y = self.frameOfPresentedViewInContainerView.origin.y
            } else {
                vc.view.frame.origin.y = UIScreen.main.bounds.height
            }
        }
        
        propertyAnimator.addCompletion { position in
            guard position == .end else { return }
            transitionContext.completeTransition(true)
        }
        
        propertyAnimator.startAnimation()
    }
}

extension ExpandableSheetPresentation: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        self
    }
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil//isInteractive ? interactor : nil
    }
}

extension ExpandableSheetPresentation {
    enum Constants {
        static let height: CGFloat = .totalHeight * 0.5 - 50
        static let tabHeight: CGFloat = 7.5
    }
}


extension UIViewController {
    func presentExpandableSheet(_ target: UIViewController) {
        let presenter = ExpandableSheetPresentation(presentedViewController: target, presenting: self)
        target.modalPresentationStyle = .custom
        target.transitioningDelegate = presenter
        self.present(target, animated: true, completion: nil)
    }
}

