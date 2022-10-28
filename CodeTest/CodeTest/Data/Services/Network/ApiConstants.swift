//
//  ApiConstants.swift
//  CodeTest
//
//  Created by Edwin Peña on 6/10/22.
//

import Foundation

enum Environment {

    // MARK: - Plist

    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    static let apiUrl: URL = {
        guard let apiUrlString = Environment.infoDictionary["API_URL"] as? String,
            let url = URL(string: "https://\(apiUrlString)") else {
            fatalError("Api Url is not set in plist for this environment")
        }
        return url
    }()
}
