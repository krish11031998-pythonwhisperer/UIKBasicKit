//
//  CommonPublishers.swift
//  MPC
//
//  Created by Krishna Venkatramani on 23/03/2023.
//

import Foundation
import Combine

public typealias SharePublisher<T,E: Error> = Publishers.MakeConnectable<Publishers.Share<AnyPublisher<T,E>>>
public typealias ConnectablePublisher<T,E: Error> = Publishers.MakeConnectable<AnyPublisher<T, E>>
public typealias StringPublisher<E: Error> = AnyPublisher<String, E>
public typealias BoolPublisher<E: Error> = AnyPublisher<Bool, E>
public typealias IntPublisher<E: Error> = AnyPublisher<Int, E>
public typealias VoidPublisher = AnyPublisher<Void, Never>
