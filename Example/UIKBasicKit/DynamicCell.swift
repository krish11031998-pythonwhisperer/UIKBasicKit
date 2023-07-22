//
//  DynamicCell.swift
//  UIKBasicKit_Example
//
//  Created by Krishna Venkatramani on 21/07/2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import UIKBasicKit
import Combine

extension UIImageView {
    
    enum ImageError: String, Error {
        case imageDecodingFailed
    }
    
    func loadImage(urlStr: String) -> AnyCancellable? {
        image = nil
        guard let url = URL(string: urlStr) else { return nil }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ (data, _) in
                guard let img = UIImage(data: data) else {
                    throw ImageError.imageDecodingFailed
                }
                return img
            })
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("(DEBUG) Error while loading the image: ", err.localizedDescription)
                default:
                    break
                }
            } receiveValue: { [weak self] in
                self?.image = $0
            }
        
    }
    
}

class DynamicCellView: UIView, ConfigurableViewElement {
    
    private lazy var imageView: UIImageView = { .init() }()
    private lazy var cellName: UILabel = { .init() }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView.heightConstraint.constant != frame.height * 0.8  {
            imageView.setHeight(height: frame.height * 0.8)
        }
    }
    
    private func setupView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        cellName.textAlignment = .justified
        
        let stack = UIStackView.VStack(subViews: [imageView, cellName], spacing: 0)
        addSubview(stack)
        stack.fillSuperview(inset: .zero)
        
        stack.cornerRadius = 12
        stack.addShadow()
    }
    
    public func configure(with model: String) {
        "Cell \(model)"
            .styled(.systemFont(ofSize: 12, weight: .regular), color: .black)
            .render(target: cellName)
        
        UIImage.randomImages(idx: Int(model) ?? 0).render(on: imageView)
    }
    
}

typealias DynamicCell = CollectionCellBuilder<DynamicCellView>
