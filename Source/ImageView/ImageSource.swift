//
//  ImageSource.swift
//  Pods-UIKBasicKit_Example
//
//  Created by Krishna Venkatramani on 22/07/2023.
//

import Foundation

public enum ImageSource {
    case remote(url: String)
    case local(img: UIImage)
    case asset(img: AssetCatalogue, tintColor: UIColor? = nil)
    case none
}

extension ImageSource: Codable {
    public init(from decoder: Decoder) throws {
        guard let url = try? decoder.singleValueContainer().decode(String.self) else {
            self = .none
            return
        }
        self = .remote(url: url)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .remote(let url):
            try container.encode(url)
        default:
            break
        }
    }
    
    public init(asset: AssetCatalogue,
                withTint tintColor: UIColor? = nil) {
        self = .asset(img: asset, tintColor: tintColor)
    }
}

public extension ImageSource {
    
    func render<T: AnyObject>(on obj: T, size: CGSize? = nil) {
        switch self {
        case .remote(let url):
            if let imageContainer = obj as? CacheableImageContainer {
                imageContainer.loadImage(url: url, size: size)
            }
        case .local(let img):
            if let size {
                img.resized(size: size).render(on: obj)
            } else {
                img.render(on: obj)
            }
        case .asset(let catalogue, let tint):
            var img: UIImage
            if let color = tint {
                img = catalogue.image(withTint: color)
            } else {
                img = catalogue.image
            }
            if let size {
                img.resized(size: size).render(on: obj)
            } else {
                img.render(on: obj)
            }
        default:
            break
        }
    }
    
    var img: UIImage? {
        switch self {
        case .local(let img):
            return img
        case .asset(let asset, _):
            return asset.image
        case .remote(let urlStr):
            return ImageDownloadManager.shared[urlStr]
        default:
            return nil
        }
    }
}

public extension UIImage {
    func render(on obj: AnyObject) {
        switch obj {
        case let imgView as UIImageView:
            imgView.image = self
        case let button as UIButton:
            button.setImage(self, for: .normal)
        default:
            break
        }
    }
}

