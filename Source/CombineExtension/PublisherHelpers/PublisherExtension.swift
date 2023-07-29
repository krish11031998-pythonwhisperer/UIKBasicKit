//
//  PublisherExtension.swift
//  MPC
//
//  Created by Krishna Venkatramani on 23/03/2023.
//

import Foundation
import Combine
import UIKit

public enum MemoryError: String, Error {
    case outOfMemory
}
//MARK: - Publisher
public extension Publisher {
    
    func unretainedSelf<T: AnyObject>(_ obj: T) -> AnyPublisher<(T, Self.Output), Self.Failure> {
        self.tryMap { [weak obj] in
            guard let validObj = obj else { throw MemoryError.outOfMemory }
            return (validObj, $0)
        }
        .catch {
            Swift.print("(ERROR) err@unretainedSelf : ", $0.localizedDescription)
            return Empty(outputType: (T, Self.Output).self, failureType: Self.Failure.self)
        }
        .eraseToAnyPublisher()
    }
    
    func sinkReceive(_ receiveCompletion: @escaping (Self.Output) -> Void) -> AnyCancellable {
        self
            .receive(on: DispatchQueue.main)
            .sink {
                if let err = $0.err?.localizedDescription {
                    Swift.print("(ERROR) err: ", err)
                }
            } receiveValue: { receiveCompletion($0) }

    }
    
    func sinkReceive(displayAlert: UIViewController?, handle: PassthroughSubject<Void, Never>? = nil, _ receiveCompletion: @escaping (Self.Output) -> Void) -> AnyCancellable {
        self
            .receive(on: DispatchQueue.main)
            .sink { //[weak displayAlert] in
                if let err = $0.err?.localizedDescription {
                    //displayAlert?.showAlert(title: "Error", body: err, buttonText: "Ok", handle: handle)
                    Swift.print("(ERROR) err: ", err)
                }
            } receiveValue: { receiveCompletion($0) }

    }
    
    func mapToVoid() -> AnyPublisher<Void, Self.Failure> {
        self.map { _ in () }.eraseToAnyPublisher()
    }
}



//MARK: - Publisher + DataResult
public extension Publisher where Self.Output: DataResult {
    
    func tableCellMap(_ transform: @escaping (Self.Output.Model) -> [TableCellProvider]) -> Publishers.Map<Self, TableCellResult> {
        self
            .map { result in
                guard let data = result.data else {
                    return TableCellResult(data: nil, err: result.err)
                }
                let cell = transform(data)
                return TableCellResult(data: cell, err: nil)
            }
    }
}

//MARK: - Publisher + TableCellResult
public extension Publisher where Self.Output == TableCellResult {
    
    func mapIntoSection(_ transform: @escaping ([TableCellProvider]) -> TableSectionResult) -> Publishers.Map<Self, TableSectionResult> {
        self
            .map { cellsData in
                guard let cells = cellsData.data else { return .init(data: nil, err: "Empty Cells!") }
                return transform(cells)
            }
    }
    
}


//MARK: - Publisher + TableSectionResult
public extension Publisher where Self.Output == TableSectionResult {
    
    func sinkForTable(_ transform: @escaping ([TableSection]) -> Void) -> AnyCancellable {
        self.sinkReceive { result in
            guard let data = result.data else { return }
            transform(data)
        }
    }
    
}

//MARK: - Publishers + Error
public extension Publisher where Self.Failure == Error {
    
    func catchErrMessage(_ errMsg: PassthroughSubject<String, Never>) -> AnyPublisher<Self.Output, Never> {
        self
            .catch {[weak errMsg] err in
                errMsg?.send(err.localizedDescription)
                return Empty<Self.Output, Never>().eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
