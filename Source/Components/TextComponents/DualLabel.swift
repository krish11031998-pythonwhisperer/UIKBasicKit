//
//  DualLabel.swift
//  UIKBasicKit
//
//  Created by Krishna Venkatramani on 29/07/2023.
//

import Foundation
import UIKit

public enum DualLabelSpacer {
    case leading, center, trailing, none
}

public class DualLabel: UIView {
    
    private lazy var title: UILabel = { .init() }()
    private lazy var subTitle: UILabel = { .init() }()
    private let spacing: CGFloat
    private let alignment: UIStackView.Alignment
    private let axis: NSLayoutConstraint.Axis
    private let addSpacer: DualLabelSpacer
    private lazy var stack: UIStackView = { .VStack(subViews: [title, subTitle], spacing: spacing, alignment: alignment) }()
    
    public init(spacing: CGFloat,
         axis: NSLayoutConstraint.Axis = .vertical,
         addSpacer: DualLabelSpacer = .none,
         alignment: UIStackView.Alignment = .fill) {
        self.spacing = spacing
        self.axis = axis
        self.addSpacer = addSpacer
        self.alignment = alignment
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        switch addSpacer {
        case .leading:
            stack.insertArrangedSubview(.spacer(), at: 0)
        case .center:
            stack.insertArrangedSubview(.spacer(), at: 1)
        case .trailing:
            stack.addArrangedSubview(.spacer())
        default:
            break
        }
        
        stack.axis = axis
        
        addSubview(stack)
        setFittingConstraints(childView: stack, insets: .zero)
    }
    
    public func configure(title: RenderableText? = nil, subtitle: RenderableText? = nil) {
        if let validTitle = title {
            validTitle.render(target: self.title)
            self.title.isHidden = false
        } else {
            self.title.isHidden = true
        }
        
        if let validSubtitle = subtitle {
            validSubtitle.render(target: self.subTitle)
            self.subTitle.isHidden = false
        }  else {
            self.subTitle.isHidden = true
        }
    }
    
    public func insets(_ inset: UIEdgeInsets) {
        stack.addInsets(insets: inset)
    }
    
    public func setNumberOfLines(forTitle: Int = 1, forSubtitle: Int = 1) {
        title.numberOfLines = forTitle
        subTitle.numberOfLines = forSubtitle
    }
    
    public func textAlignment(forTitle: NSTextAlignment = .center, forSubtitle: NSTextAlignment = .center) {
        title.textAlignment = forTitle
        subTitle.textAlignment = forSubtitle
    }
    
    public func setCompressedHeight() {
        self.layoutIfNeeded()
        let titleHeight = self.title.text?.height(withWidth: self.bounds.width - 10, font: self.title.font) ?? 0
        let subTitleHeight = self.subTitle.text?.height(withWidth: self.bounds.width, font: self.subTitle.font) ?? 0
        setHeight(height: ceil(titleHeight) + ceil(subTitleHeight) + stack.spacing)
    }
}

