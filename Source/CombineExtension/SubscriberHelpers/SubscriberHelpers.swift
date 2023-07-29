//
//  SubscriberHelpers.swift
//  MPC
//
//  Created by Krishna Venkatramani on 19/12/2022.
//

import Foundation
import Combine


public extension Subscribers.Completion {
    
    var err: Error? {
        switch self {
        case .finished:
            return nil
        case .failure(let failure):
            return failure
        }
    }
    
}
