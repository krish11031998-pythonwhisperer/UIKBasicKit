//
//  UILabel.swift
//  UIKLayout
//
//  Created by Krishna Venkatramani on 13/07/2023.
//

import UIKit

public extension UIView {
    
    func blobify(backgroundColor: UIColor = .white.withAlphaComponent(0.2),
                 edgeInset: UIEdgeInsets = .init(vertical: 5, horizontal: 7.5),
                 borderColor: UIColor = .clear,
                 borderWidth: CGFloat = 0,
                 cornerRadius: CGFloat = 12) -> UIView {
        let view = embedInView(insets: edgeInset, priority: .needed)
        view.backgroundColor = backgroundColor
        view.border(color: borderColor, borderWidth: borderWidth, cornerRadius: cornerRadius)
        return view
    }
    
    func embedViewInCard(backgroundColor: UIColor = .white,
                         borderColor: UIColor = .clear,
                         borderWidth: CGFloat = 0,
                         cornerRadius: CGFloat = 12) -> UIView {
        let view = blobify(backgroundColor: backgroundColor,
                            edgeInset: .init(vertical: 10, horizontal: 12.5),
                            borderColor: borderColor,
                            borderWidth: borderWidth,
                            cornerRadius: cornerRadius)
        return view
    }
}


public extension UILabel {
    func fitHeightForText(width: CGFloat = .totalWidth) {
        guard let font = attributedText?.attributedFont, let content = attributedText?.content else { return }
        let height = content.height(withWidth: width, font: font)
        setHeight(height: height + 20)
    }
    
    convenience init(numberOfLines: Int) {
        self.init()
        self.numberOfLines = numberOfLines
    }
}
