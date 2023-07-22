//
//  CacheableImageContainer.swift
//  Pods-UIKBasicKit_Example
//
//  Created by Krishna Venkatramani on 22/07/2023.
//

import Foundation


//MARK: - CacheableImageContainer
protocol CacheableImageContainer: UIView {
    static var imgURLPropertyKey: UInt8 { get set }
    var imgURL: String? { get set }
    var containerImage: UIImage? { get set }
    func setImage(img: UIImage)
    func checkAndResetIfSameViewLoadingImage(urlStr: String) -> Bool
    func loadImage(url urlStr: String, size: CGSize?)
}

extension CacheableImageContainer{
    
    func setImage(img: UIImage) {
        DispatchQueue.main.async {
            UIView.transition(with: self, duration: 0.3, options: [.transitionCrossDissolve]) {
                self.containerImage = img
            }
        }
    }
    
    func checkAndResetIfSameViewLoadingImage(urlStr: String) -> Bool {
       guard let url = URL(string: urlStr) else {
           self.containerImage = nil//.placeHolder
           return true
       }
       
       guard let img = ImageDownloadManager.shared[.init(url: url)] else {
           self.containerImage = nil//.placeHolder
           return true
       }
       
       guard img != self.containerImage else { return false }
       
       self.setImage(img: img)
       return false
   }
    
    func loadImage(url urlStr: String, size: CGSize? = nil) {
        self.imgURL = urlStr
        
        guard self.checkAndResetIfSameViewLoadingImage(urlStr: urlStr) else { return }
        
        ImageDownloadManager.shared.loadImage(urlStr: urlStr) { [weak self] in
            guard let self else { return }
            switch $0 {
            case .success(let img):
                guard self.imgURL == urlStr else { return }
                self.setImage(img: img)
            case .failure(let err):
                print("(ERROR) while downloading Image: ", err.localizedDescription)
            }
        }
    }

}

//MARK: - UIImageView+CacheableImageContainer
extension UIImageView: CacheableImageContainer {
    static var imgURLPropertyKey: UInt8 = 1
    var imgURL: String? {
        get { objc_getAssociatedObject(self, &Self.imgURLPropertyKey) as? String }
        set { objc_setAssociatedObject(self, &Self.imgURLPropertyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    @objc var containerImage: UIImage? {
        get { image }
        set { self.image = newValue }
    }
}
