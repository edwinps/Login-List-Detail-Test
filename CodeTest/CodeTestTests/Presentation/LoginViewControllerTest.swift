//
//  LoginViewController.swift
//  CodeTestTests
//
//  Created by Edwin Peña on 9/10/22.
//

import Foundation
import XCTest
@testable import CodeTest

class LoginViewControllerTest: XCTestCase {
    // MARK: - System Under Test
    private var sut: LoginViewController!

    // MARK: Mocks
    private var mockViewModel: MockLoginViewModel!

    // MARK: Tests Methods

    override func setUp() {
        super.setUp()
        mockViewModel
            .loadImageUseCase
            .loadImageForReturnValue = .just(Data())
        sut = LoginViewController(viewModel: mockViewModel)
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        mockViewModel = nil
        super.tearDown()
    }

//    func test_afterViewDidLoad() {
//        let window = UIWindow()
//        loadView(window)
//    }
//
//    func loadView(_ window: UIWindow) {
//        window.addSubview(sut.view)
//        RunLoop.current.run(until: Date())
//    }
}
