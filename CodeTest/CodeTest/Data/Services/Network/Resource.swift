//
//  Resource.swift
//  CodeTest
//
//  Created by Edwin Peña on 6/10/22.
//

import Foundation

enum RequestMethod: String {
    case post
    case get
}

struct Resource<T: Decodable> {
    let url: URL
    private let parameters: [String: CustomStringConvertible]
    private let body: Data?
    private let method: RequestMethod?
    private var headers: [String : String] = ["Content-Type": "application/json"]
    private let token: String?

    var request: URLRequest? {
        guard var components = URLComponents(url: url,
                                             resolvingAgainstBaseURL: false) else {
            return nil
        }
        components.queryItems = parameters.keys.map { key in
            URLQueryItem(name: key, value: parameters[key]?.description)
        }
        guard let url = components.url else {
            return nil
        }

        var request = URLRequest(url: url)
        if let auth = token {
            request.setValue("Bearer \(auth)", forHTTPHeaderField: "Authorization")
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        request.httpMethod = method?.rawValue
        return request
    }

    init(url: URL,
         parameters: [String: CustomStringConvertible] = [:],
         body: Data? = nil,
         method: RequestMethod = .get,
         token: String? = nil
    ) {
        self.url = url
        self.parameters = parameters
        self.body = body
        self.method = method
        self.token = token
    }
}

