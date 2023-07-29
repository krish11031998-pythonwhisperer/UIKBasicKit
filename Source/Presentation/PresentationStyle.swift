//
//  PresentationStyle.swift
//  MPC
//
//  Created by Krishna Venkatramani on 13/11/2022.
//

import Foundation
import UIKit

//MARK: - PresentationStyle
public enum PresentationStyle {
    case circlar(frame: CGRect, swipeToDismiss: Bool = false)
    case sheet(size: CGSize = .totalScreenSize, edge: UIEdgeInsets = .zero, swipeToDismiss: Bool = false)
    case matchedGeometryEffect(frame: CGRect, size: CGSize = .totalScreenSize)
    case dynamic
}

public extension UIViewController {
    var viewHeight: CGFloat {
        compressedSize.height + .safeAreaInsets.bottom + navBarHeight
    }
}

public extension PresentationStyle {
    func originalFrame(view: UIViewController) -> CGRect {
        switch self {
        case .circlar(let frame, _):
            return frame
        case .sheet(let size, let edge, _):
            return .init(origin: .init(x: edge.left, y: .totalHeight), size: .init(width: size.width - (edge.left + edge.right), height: size.height - edge.bottom))
        case .matchedGeometryEffect(let frame, _):
            return frame
        case .dynamic:
            let lastView = (view as? UINavigationController)?.viewControllers.last ?? view
            return .init(origin: .init(x: .zero,
                                       y: .totalHeight),
                         size: .init(width: .totalWidth,
                                     height: lastView.preferredContentHeight))
        }
    }
    
    var cornerRadius: CGFloat? {
        switch self {
        case .circlar(let frame, _):
            return frame.size.smallDim.half
        case .sheet, .dynamic, .matchedGeometryEffect:
            return nil
        }
    }
    
    var frameOfPresentedView: CGRect? {
        switch self {
        case .circlar:
            return .init(origin: .zero, size: .init(width: .totalWidth, height: .totalHeight))
        case .sheet(let size, let edge, _):
            return .init(origin: .init(x: edge.left, y: .totalHeight - size.height), size: .init(width: size.width - (edge.left + edge.right), height: size.height - edge.bottom))
        case .matchedGeometryEffect(_, let size):
            return size.bounds
        case .dynamic:
            return nil
        }
    }
    
    var initScale: CGFloat {
        switch self {
        case .circlar:
            return 0.9
        case .sheet, .dynamic:
            return 1
        case .matchedGeometryEffect:
            return 1
        }
    }
    
    var transitionDuration: TimeInterval {
        switch self {
        case .circlar:
            return 0.2
        case .sheet, .dynamic:
            return 0.3
        case .matchedGeometryEffect:
            return 3
        }
    }
    
    var removeView: Bool {
        switch self {
        case .circlar:
            return true
        case .sheet, .dynamic, .matchedGeometryEffect:
            return false
        }
    }
    
    var addDimmingView: Bool {
        switch self {
        case .circlar, .sheet, .matchedGeometryEffect:
            return false
        default:
            return true
        }
    }
    
    var swipeToDismiss: Bool {
        switch self {
        case .circlar(_, let swipe), .sheet(_, _, let swipe):
            return swipe
        default:
            return false
        }
    }
    
    var hidingOnDismissal: Bool {
        switch self {
        case .matchedGeometryEffect:
            return true
        default:
            return false
        }
    }
    
    var isMatchGeometry: Bool {
        switch self {
        case .matchedGeometryEffect:
            return true
        default:
            return false
        }
    }
    
    var isOverlay: Bool {
        switch self {
        case .sheet,  .dynamic:
            return true
        default:
            return false
        }
    }
}
