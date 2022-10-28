//
//  CodeTestCase.swift
//  CodeTestTests
//
//  Created by Edwin Peña on 9/10/22.
//

import XCTest
@testable import CodeTest

class CodeTestCase: NSObject { }

extension Decodable {
    static func loadFromFile(_ filename: String) -> Self {
        do {
            let path = Bundle(for: CodeTestCase.self).path(forResource: filename, ofType: nil)!
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            return try JSONDecoder().decode(Self.self, from: data)
        } catch {
            fatalError("Error: \(error)")
        }
    }
}
