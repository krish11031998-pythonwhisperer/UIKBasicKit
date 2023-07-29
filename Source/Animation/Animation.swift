//
//  Animation.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/09/2022.
//

import Foundation
import UIKit

public enum AnimationDirection {
    case up
    case down
    case left
    case right
}

public enum AnimationState {
    case `in`
    case out
}

public enum Animation {
    //MARK: Slide
	case slideInFromTop(from: CGFloat, to:CGFloat = 0, duration: CFTimeInterval = 0.3)
    case slide(_ direction: AnimationDirection, state: AnimationState = .in, additionalOff: CGFloat = 0, duration: CFTimeInterval = 0.3)
    case transformX(by: CGFloat, duration: CFTimeInterval = 0.3)

    //MARK: Fade
    case fadeIn(duration: CFTimeInterval = 0.3)
    case fadeOut(to: CGFloat = 0, duration: CFTimeInterval = 0.3)
    case fadeInOut(duration: CGFloat = 0.75)
    
    //MARK: Progress
    case lineProgress(frame: CGRect, roundedCorners: Bool = true, duration: CFTimeInterval = 0.3)
    case circularProgress(from: CGFloat = 0, to: CGFloat, duration: CFTimeInterval = 0.33, delay: CFTimeInterval = 0)
    
    //MARK: Misc
    case shakeUpDown(duration: CGFloat = 0.3)
    case bouncy
}

//MARK: - Animation Helpers
public extension Animation {
	
	func animationData(at layer: CALayer) -> CAAnimation {
		
		switch self {
        case .bouncy:
            let animation = CAKeyframeAnimation(keyPath: "transform.scale")
            animation.keyTimes = [0, 0.33, 0.66, 1]
            animation.values = [1, 0.975, 0.975, 1]
            return animation
		case .slideInFromTop(let from, let to, let duration):
			let animation = CABasicAnimation(keyPath: "position.y")
			animation.fromValue = from
			animation.toValue = to

			let opacity = CABasicAnimation(keyPath: "opacity")
			opacity.fromValue = 0
			opacity.toValue = 1
			
			let group = CAAnimationGroup()
			group.animations = [animation, opacity]
			group.duration = duration
			
			return group
        case .slide(let direction, let state, let additionalOff, let  duration):
            let animation = CABasicAnimation(keyPath: "position.y")

            switch direction {
                case .up:
                animation.fromValue = state == .in ? -layer.frame.height : layer.frame.height
                animation.toValue = (state == .in ? layer.frame.height : -layer.frame.height) + additionalOff * (state == .in ? 1 : -1)
                case .down:
                animation.fromValue = .totalHeight + layer.frame.height.half * (state == .in ? 1 : -1)
                animation.toValue = (.totalHeight + layer.frame.height.half * (state == .in ? -1 : 1)) + additionalOff * (state == .in ? -1 : 1)
                default: break;
            }
            animation.duration = duration
            animation.isRemovedOnCompletion = false
            animation.fillMode = .forwards
            return animation
        case .transformX(let to, let duration):
            let animation = CABasicAnimation(keyPath: "position.x")
            animation.toValue = layer.frame.midX + to
            animation.duration = duration
            return animation
		case .circularProgress(let from, let to, let duration, let delay):
			let animation = CABasicAnimation(keyPath: "strokeEnd")
			animation.fromValue = from
			animation.toValue = to
			animation.duration = duration
            animation.beginTime = CACurrentMediaTime() + delay
            animation.isRemovedOnCompletion = false
            animation.fillMode = .forwards
			return animation
        case .lineProgress(let frame, let rounded, let duration):
            let animation = CABasicAnimation(keyPath: "path")
            if rounded {
                animation.toValue = UIBezierPath(roundedRect: frame, cornerRadius: frame.size.smallDim.half).cgPath
            } else {
                animation.toValue = UIBezierPath(rect: frame).cgPath
            }
            
            animation.duration = duration
            animation.isRemovedOnCompletion = false
            animation.fillMode = .forwards
            return animation
        case .fadeIn(let duration):
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.toValue = 1
            animation.duration = duration
            return animation
        case .fadeOut(let to, let duration):
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.toValue = to
            animation.duration = duration
            return animation
        case .fadeInOut(let duration):
            let animation = CAKeyframeAnimation(keyPath: "opacity")
            animation.keyTimes = [0, 0.15, 0.5, 0.85, 1]
            animation.values = [0, 0.75, 1, 0.75, 0]
            animation.duration = duration
            return animation
        case .shakeUpDown(let duration):
            let animation = CAKeyframeAnimation(keyPath: "position.y")
            animation.keyTimes = [0, 0.3, 0.6, 1]
            animation.values = [-5, 0, 5, 0]
            animation.autoreverses = true
            animation.repeatCount = .infinity
            animation.duration = duration
            return animation
		}
		
	}
	
    static func combining(at layer: CALayer, animation: [Animation], removeAfterCompletion: Bool = false ) -> CAAnimation {
        let group = CAAnimationGroup()
        group.animations = animation.compactMap { $0.animationData(at: layer)}
        return group
    }
    
    var name: String {
        switch self {
        case .bouncy:
            return "bouncy"
        case .slideInFromTop:
            return "slideInFromTop"
        case .slide:
            return "slide"
        case .transformX:
            return "transformX"
        case .circularProgress:
            return "circularProgress"
        case .lineProgress:
            return "lineProgress"
        case .fadeIn:
            return "fadeIn"
        case .fadeOut:
            return "fadeOut"
        case .shakeUpDown:
            return "slideUpDown"
        case .fadeInOut:
            return "fadeInOut"
        }
    }
}

//MARK: - Array + Animation
public extension Array where Element == Animation {
    
    func combine(at layer: CALayer, removeAfterCompletion: Bool) -> CAAnimation {
        Animation.combining(at: layer, animation: self, removeAfterCompletion: removeAfterCompletion)
    }
    
}

//MARK: - Animation Names

