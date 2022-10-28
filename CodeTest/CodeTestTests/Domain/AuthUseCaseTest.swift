//
//  AuthUseCaseTest.swift
//  CodeTestTests
//
//  Created by Edwin Peña on 9/10/22.
//

import Foundation
import XCTest
import Combine
@testable import CodeTest

class AuthUseCaseTest: XCTestCase {
    private var sut: AuthUseCase!
    private var keychainMock: KeychainMock<String>!

    override func setUp() {
        super.setUp()
        keychainMock = KeychainMock<String>()
        sut = AuthUseCase(keychainHelper: keychainMock)
    }

    override func tearDown() {
        sut = nil
        keychainMock = nil
        super.tearDown()
    }

    func test_getToken() {
        // Given
        keychainMock.readItemReturn = "token"

        // When
        let newToken = sut.token

        // Then
        XCTAssertEqual(newToken, "token")
    }

    func test_setToken_changeValue() {
        // Given
        keychainMock.readItemReturn = "token"

        // When
        sut.setToken("new Token")

        // Then
        XCTAssert(keychainMock.saveItemCalled)
    }

    func test_deleteToken() {
        // When
        sut.deleteAuth()

        // Then
        XCTAssert(keychainMock.deleteServiceCalled)
    }
}
