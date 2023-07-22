//
//  UIView+Array.swift
//  Dekrypt
//
//  Created by Krishna Venkatramani on 09/02/2023.
//

import Foundation
import UIKit

//MARK: - UIView + Array<UIView>
public extension Array where Element : UIView {
    
    func sizeFittingStack(for width: CGFloat, with spacing: CGFloat = .zero) -> [[UIView]] {
        var result: [[UIView]] = []
        
        var rowStack: [UIView] = []
        var remainingSpace = width
        
        forEach {

            let size = $0.compressedSize
            
            if size.width == width {
                result.append([$0])
            } else if size.width >= remainingSpace {
                if !rowStack.isEmpty { result.append(rowStack) }
                rowStack.removeAll()
                remainingSpace = width
            }
            
            rowStack.append($0)
            remainingSpace -= size.width + spacing
        }
        
        if !rowStack.isEmpty { result.append(rowStack) }
        
        return result
    }
    
    func addToView(_ main: UIView, removeChildren: Bool = false) {
        if removeChildren {
            main.removeChildViews()
        }
        if let stack = main as? UIStackView {
            forEach(stack.addArrangedSubview(_:))
        } else {
            forEach(main.addSubview(_:))
        }
    }
    
    
    func embedInVStack(alignment: UIStackView.Alignment = .fill, spacing: CGFloat = 0, distribution: UIStackView.Distribution = .fill) -> UIStackView {
        let stack = UIStackView.VStack(subViews: self, spacing: spacing, alignment: alignment)
        stack.distribution = distribution
        return stack
    }
    
    
    func embedInHStack(alignment: UIStackView.Alignment = .fill, spacing: CGFloat = 0, distribution: UIStackView.Distribution = .fill) -> UIStackView {
        let stack = UIStackView.HStack(subViews: self, spacing: spacing, alignment: alignment)
        stack.distribution = distribution
        return stack
    }
}

