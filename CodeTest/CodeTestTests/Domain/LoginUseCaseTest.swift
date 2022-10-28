//
//  LoginUseCaseTest.swift
//  CodeTestTests
//
//  Created by Edwin Peña on 9/10/22.
//

import Foundation
import XCTest
import Combine
@testable import CodeTest

class LoginUseCaseTest: XCTestCase {
    private var sut: LoginUseCase!
    private var networkService: NetworkServiceMock!
    private var disposables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        networkService = NetworkServiceMock()
        sut = LoginUseCase(networkService: networkService)
    }

    override func tearDown() {
        sut = nil
        networkService = nil
        super.tearDown()
    }

    func test_getTokenSucceeds() {
        // Given
        var result: Result<AuthToken, Error>!
        let expectation = expectation(description: "AuthToken")
        let articles = AuthToken.loadFromFile("AuthToken.json")
        networkService.responses["/auth/token"] = articles

        // When
        sut.getToken(userName: "code",
                      password: "test")
            .sink { value in
            result = value
            expectation.fulfill()
        }.store(in: &disposables)

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        guard case .success = result! else {
            XCTFail()
            return
        }
        XCTAssert(networkService.requestCalled)
    }

    func test_getTokenFailes_onError() {
        // Given
        var result: Result<AuthToken, Error>!
        let expectation = expectation(description: "authToken")
        networkService.responses["/auth/token"] = NetworkError.invalidResponse

        // When
        sut.getToken(userName: "code",
                      password: "test")
        .sink { value in
            result = value
            expectation.fulfill()
        }.store(in: &disposables)

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        guard case .failure = result! else {
            XCTFail()
            return
        }
        XCTAssert(networkService.requestCalled)
    }
}
