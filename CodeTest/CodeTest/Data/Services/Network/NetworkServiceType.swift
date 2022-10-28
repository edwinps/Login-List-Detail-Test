//
//  NetworkServiceType.swift
//  CodeTest
//
//  Created by Edwin Peña on 6/10/22.
//

import Foundation
import Combine

protocol NetworkServiceType: AnyObject {
    @discardableResult
    func request<T>(_ resource: Resource<T>) -> AnyPublisher<T, Error>
}

/// Defines the Network service errors.
enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case unAuthorized
    case dataLoadingError(statusCode: Int, data: Data)
    case jsonDecodingError(error: Error)
}

