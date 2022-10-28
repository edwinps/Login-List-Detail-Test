//
//  LoadImageUseCaseTest.swift
//  CodeTestTests
//
//  Created by Edwin Peña on 9/10/22.
//

import Foundation
import XCTest
import Combine
@testable import CodeTest

class LoadImageUseCaseTest: XCTestCase {
    private var sut: LoadImageUseCase!
    private var imageLoaderService: ImageLoaderServiceMock!
    private var disposables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        imageLoaderService = ImageLoaderServiceMock()
        sut = LoadImageUseCase(imageLoaderService: imageLoaderService)
    }

    override func tearDown() {
        sut = nil
        imageLoaderService = nil
        super.tearDown()
    }

    func test_loadImage_Succeeds() {
        // Given
        var result: Data?
        let expectation = expectation(description: "load Image")
        imageLoaderService.loadImageFromReturnValue = .just(Data())

        // When
        sut.loadImage(for: "https://google.com")
            .sink { value in
            result = value
            expectation.fulfill()
        }.store(in: &disposables)

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(result)
        XCTAssert(imageLoaderService.loadImageFromCalled)
    }

    func test_loadImageFailes_ReturnNil() {
        // Given
        var result: Data?
        let expectation = expectation(description: "load Image")
        imageLoaderService.loadImageFromReturnValue = .just(nil)

        // When
        sut.loadImage(for: "https://google.com")
        .sink { value in
            result = value
            expectation.fulfill()
        }.store(in: &disposables)

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNil(result)
        XCTAssert(imageLoaderService.loadImageFromCalled)
    }

    func test_loadImageFailes_wrongURL() {
        // Given
        var result: Data?
        let expectation = expectation(description: "load Image")

        // When
        sut.loadImage(for: "")
        .sink { value in
            result = value
            expectation.fulfill()
        }.store(in: &disposables)

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNil(result)
        XCTAssertFalse(imageLoaderService.loadImageFromCalled)
    }
}
