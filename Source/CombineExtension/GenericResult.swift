//
//  GenericResult.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 29/12/2022.
//

import Foundation

//MARK: - DataResult + GenericResult
public protocol DataResult {
    associatedtype Model: Codable
    var data: Model? { get set }
    var err: String? { get set }
    var success: Bool { get set }
}

public struct GenericResult<T:Codable>: DataResult, Codable {
    public var data: T?
    public var err: String?
    public var success: Bool
}

typealias GenericMessageResult = GenericResult<String>

//MARK: - StreamResult + GenericDownsStreamResult
public protocol StreamResult {
    associatedtype Model
    var data: Model? { get set }
    var err: String? { get set }
}

public struct GenericDownstreamResult<T>: StreamResult {
    public var data: T?
    public var err: String?
}

public typealias TableSectionResult = GenericDownstreamResult<[TableSection]>
public typealias TableCellResult = GenericDownstreamResult<[TableCellProvider]>
