//
//  LoginViewModelTest.swift
//  CodeTestTests
//
//  Created by Edwin Peña on 9/10/22.
//

import Foundation
import XCTest
import Combine
@testable import CodeTest

class LoginViewModelTest: XCTestCase {
    private var sut: LoginViewModel!
    private var authUseCase: AuthUseCaseMock!
    private var loadImageUseCase: LoadImageUseCaseMock!
    private var loginUseCase: LoginUseCaseMock!
    private var coordinator: CoordinatorMock!
    private var disposables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        coordinator = CoordinatorMock()
        authUseCase = AuthUseCaseMock()
        loadImageUseCase = LoadImageUseCaseMock()
        loginUseCase = LoginUseCaseMock()
        sut = LoginViewModel(coordinator: coordinator,
                             authUseCase: authUseCase,
                             loadImageUseCase: loadImageUseCase,
                             loginUseCase: loginUseCase)
    }

    override func tearDown() {
        sut = nil
        coordinator = nil
        authUseCase = nil
        loadImageUseCase = nil
        loginUseCase = nil
        super.tearDown()
    }

    private func createInput(
        willAppear: AnyPublisher<Void, Never> = .empty(),
        userName: AnyPublisher<String, Never> = .empty(),
        password: AnyPublisher<String, Never> = .empty(),
        loginAction: AnyPublisher<Void, Never> = .empty()
    )
        -> LoginViewModel.Input
    {
        return LoginViewModel
            .Input(willAppear: willAppear,
                   userName: userName,
                   password: password,
                   loginAction: loginAction)
    }

    func test_viewWillAppear_returnHeaderImage() {
        // Given
        let expectation = expectation(description: "Header Image")
        let trigger = PassthroughSubject<Void, Never>()
        let input = createInput(willAppear: trigger.eraseToAnyPublisher())
        let output = sut.transform(input: input)
        var actualsModel: Data?
        loadImageUseCase.loadImageForReturnValue = .just(Data())

        // When
        output.headerImage.sink { header in
            actualsModel = header
            expectation.fulfill()
        }.store(in: &disposables)

        trigger.send(())

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(actualsModel)
        XCTAssert(loadImageUseCase.loadImageForCalled)
    }

    func test_loginAction_withLoginAccess_loginSuccess() {
        // Given
        let expectation = expectation(description: "Login Success")
        let triggerUser = PassthroughSubject<String, Never>()
        let triggerPass = PassthroughSubject<String, Never>()
        let triggerAction = PassthroughSubject<Void, Never>()
        let authToken = AuthToken(token: "token",
                                  refreshToken: "refresh")
        loginUseCase
            .getTokenUserNamePasswordReturnValue = .just(.success(authToken))
        let input = createInput(userName: triggerUser.eraseToAnyPublisher(),
                                password: triggerPass.eraseToAnyPublisher(),
                                loginAction: triggerAction.eraseToAnyPublisher())
        let output = sut.transform(input: input)
        loadImageUseCase.loadImageForReturnValue = .just(Data())

        // When
        output.openList.sink { _ in
            expectation.fulfill()
        }.store(in: &disposables)

        triggerUser.send("code")
        triggerPass.send("test")
        triggerAction.send(())

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssert(loginUseCase.getTokenUserNamePasswordCalled)
        XCTAssert(coordinator.articlesCalled)
        XCTAssert(authUseCase.setTokenCalled)
    }

    func test_loginAction_withLoginAccess_loginFailed() {
        // Given
        let expectation = expectation(description: "login Failed")
        let triggerUser = PassthroughSubject<String, Never>()
        let triggerPass = PassthroughSubject<String, Never>()
        let triggerAction = PassthroughSubject<Void, Never>()
        loginUseCase
            .getTokenUserNamePasswordReturnValue = .just(.failure(LoginError.invalidData))
        let input = createInput(userName: triggerUser.eraseToAnyPublisher(),
                                password: triggerPass.eraseToAnyPublisher(),
                                loginAction: triggerAction.eraseToAnyPublisher())
        let output = sut.transform(input: input)
        loadImageUseCase.loadImageForReturnValue = .just(Data())
        var errorResponse: Error?
        // When
        output.openList.sink { error in
            errorResponse = error
            expectation.fulfill()
        }.store(in: &disposables)

        triggerUser.send("code")
        triggerPass.send("test")
        triggerAction.send(())

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(errorResponse as? LoginError,
                       LoginError.invalidData)
        XCTAssertNotNil(errorResponse)
        XCTAssertTrue(loginUseCase.getTokenUserNamePasswordCalled)
        XCTAssertFalse(coordinator.articlesCalled)
        XCTAssertFalse(authUseCase.setTokenCalled)
    }

    func test_withLoginAccess_enable_Login() {
        // Given
        let expectation = expectation(description: "enable Login")
        let triggerUser = PassthroughSubject<String, Never>()
        let triggerPass = PassthroughSubject<String, Never>()
        let input = createInput(userName: triggerUser.eraseToAnyPublisher(),
                                password: triggerPass.eraseToAnyPublisher())
        let output = sut.transform(input: input)
        var actualsModel: Bool = false

        // When
        output.enableLogin.sink { enable in
            actualsModel = enable
            expectation.fulfill()
        }.store(in: &disposables)

        triggerUser.send("code")
        triggerPass.send("test")

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssert(actualsModel)
    }

    func test_willAppear_disable_Login() {
        // Given
        let expectation = expectation(description: "disable Login")
        let trigger = PassthroughSubject<Void, Never>()
        let input = createInput(willAppear: trigger.eraseToAnyPublisher())
        let output = sut.transform(input: input)
        var actualsModel: Bool = true

        // When
        output.enableLogin.sink { enable in
            actualsModel = enable
            expectation.fulfill()
        }.store(in: &disposables)

        trigger.send(())

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertFalse(actualsModel)
    }

    func test_willAppear_isNotLoading() {
        // Given
        let expectation = expectation(description: "is not loading")
        let trigger = PassthroughSubject<Void, Never>()
        let input = createInput(willAppear: trigger.eraseToAnyPublisher())
        let output = sut.transform(input: input)
        var actualsModel: Bool = true

        // When
        output.isLoading.sink { loading in
            actualsModel = loading
            expectation.fulfill()
        }.store(in: &disposables)

        trigger.send(())

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertFalse(actualsModel)
    }

    func test_willAppear_isLoading() {
        // Given
        let expectation = expectation(description: "is loading")
        let triggerAction = PassthroughSubject<Void, Never>()
        let input = createInput(loginAction: triggerAction.eraseToAnyPublisher())
        let output = sut.transform(input: input)
        var actualsModel: Bool = true

        // When
        output.isLoading.sink { loading in
            actualsModel = loading
            expectation.fulfill()
        }.store(in: &disposables)

        triggerAction.send(())

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssert(actualsModel)
    }
}
