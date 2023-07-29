//
//  UIButton+Publishers.swift
//  Dekrypt
//
//  Created by Krishna Venkatramani on 13/01/2023.
//

import Foundation
import Combine
import UIKit

public extension UIButton {
    
    var tapPublisher: VoidPublisher {
        self.publisher(for: .touchUpInside)
            .map { _ in () }
            .handleEvents(receiveOutput: { [weak self] _ in
                guard let self else { return }
                self.animate(.bouncy)
            })
            .eraseToAnyPublisher()
    }
    
    func onTap(_ completion: @escaping Callback) -> AnyCancellable {
        self.tapPublisher
            .sink { _ in
                completion()
            }
    }
    
}
