//
//  MainCoordinatorTest.swift
//  CodeTestTests
//
//  Created by Edwin Peña on 9/10/22.
//

import Foundation
import XCTest
import Combine
@testable import CodeTest

class MainCoordinatorTest: XCTestCase {
    private var sut: MainCoordinator!
    private var window = UIWindow()
    private var navigation = UINavigationController()
    private var dependencyProvider: ApplicationFactoryMock!

    override func setUp() {
        super.setUp()
        dependencyProvider = ApplicationFactoryMock()
        sut = MainCoordinator(window: window,
                              navigationController: navigation,
                              dependencyProvider: dependencyProvider)
    }

    override func tearDown() {
        sut = nil
        dependencyProvider = nil
        super.tearDown()
    }

    func test_start_show_LoginViewController() {
        // When
        sut.start()

        // Then
        XCTAssert(window.rootViewController is LoginViewController)
    }

    func test_articles_show_ListViewController() {
        // When
        sut.articles()

        // Then
        let nav = window.rootViewController as? UINavigationController
        let root = nav?.viewControllers.first ?? UIViewController()
        XCTAssert(root is ListViewController)
    }

    func test_showDetails_show_DetailViewController() {
        // When
        sut.showDetails(for: MockActicles.articleViewModelMock())

        // Then
        let root = navigation.viewControllers.first ?? UIViewController()
        XCTAssert(root is DetailViewController)
    }
}
