//
//  NSAttributedString+Utils.swift
//  baraka-styleui
//
//  Created by Krishna Venkatramani on 19/11/2022.
//

import Foundation
import UIKit

//MARK: - UIImage_NSTextAttachment
public extension UIImage {
    
    func toText(fontHeight: CGFloat = 0) -> NSAttributedString {
        let attachment = NSTextAttachment(image: self)
        if let img = attachment.image {
            attachment.bounds = .init(origin: .init(x: 0, y: (fontHeight - img.size.height).half), size: img.size)
        }
        return .init(attachment: attachment)
    }
}

//MARK: - NSAttributedString
public extension RenderableText where Self == NSAttributedString {
    
    func appending(_ text: RenderableText) -> NSAttributedString {
        let copy = NSMutableAttributedString(attributedString: self)
        
        if let str = text as? String {
            copy.append(NSAttributedString(string: str))
        } else if let attrStr = text as? NSAttributedString {
            copy.append(attrStr)
        }
        
        return .init(attributedString: copy)
    }
    
    var attributedFont: UIFont? {
        let attributes = self.attributes(at: 0, effectiveRange: nil)
        return attributes[.font] as? UIFont
    }
    
    var fontHeight: CGFloat {
        return attributedFont?.capHeight ?? 0
    }
    
    func addImage(_ image: UIImage) -> NSAttributedString {
        image.toText().appending(" ").appending(self)
    }
    
    static func + (lhs: UIImage?, rhs: Self) -> NSAttributedString {
        guard let validImage = lhs else { return rhs }
        return validImage.toText(fontHeight: rhs.fontHeight).appending(" ").appending(rhs)
    }
    
    static func + (lhs: Self, rhs: UIImage?) -> NSAttributedString {
        guard let validImage = rhs else { return lhs }
        return lhs.appending(" ").appending(validImage.toText(fontHeight: lhs.fontHeight))
    }
    
}
