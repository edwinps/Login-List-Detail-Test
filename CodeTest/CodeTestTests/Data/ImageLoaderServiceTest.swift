//
//  ImageLoaderServiceTest.swift
//  CodeTestTests
//
//  Created by Edwin Peña on 9/10/22.
//

import Foundation
import XCTest
import Combine
import UIKit.UIImage
@testable import CodeTest

class ImageLoaderServiceTest: XCTestCase {
    private var sut: ImageLoaderService!
    private var disposables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        sut = ImageLoaderService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_loadFinishedSuccessfully() {
        // Given
        let imageUrl = testURLForResource("image.jpeg")
        let dataImageMock = dataFrom(resource: "image.jpeg")
        var dataImage: Data? = nil
        var image: UIImage? = nil
        let expectation = expectation(description: "image result")

        // When
        sut.loadImage(from: imageUrl)
            .sink { data in
                if let data = data {
                    dataImage = data
                    image = UIImage(data: data)
                }
                expectation.fulfill()
            }.store(in: &disposables)

        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(dataImage)
        XCTAssertNotNil(image)
        XCTAssertEqual(dataImageMock, dataImage)
    }

    func test_loadFailed() {
        // Given
        let imageUrl = URL(string: "https://translate.google.com")!
        var image: UIImage? = nil
        let expectation = expectation(description: "image result")

        // When
        sut.loadImage(from: imageUrl)
            .sink { data in
                if let data = data {
                    image = UIImage(data: data)
                }
                expectation.fulfill()
            }.store(in: &disposables)

        waitForExpectations(timeout: 2.0, handler: nil)
        XCTAssertNil(image)
    }
}

func testURLForResource(_ resourceName: String) -> URL {
    return Bundle(for: ImageLoaderServiceTest.self)
        .url(forResource: resourceName, withExtension: nil)!
}

func dataFrom(resource: String) -> Data {
    let url = testURLForResource(resource)
    do {
        let data1 = try Data(contentsOf: url)
        return data1
    } catch { }

    return Data()
}
