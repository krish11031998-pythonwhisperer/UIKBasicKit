//
//  Fundamentals.swift
//  UIKBasicKit
//
//  Created by Krishna Venkatramani on 23/07/2023.
//

import Foundation
import Combine

public func asyncMain(_ callback: @escaping Callback) {
    DispatchQueue.main.async {
        callback()
    }
}

public typealias Bag = Set<AnyCancellable>
