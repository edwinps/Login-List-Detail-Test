//
//  LoginViewModel.swift
//  CodeTest
//
//  Created by Edwin Peña on 8/10/22.
//

import Foundation
import Combine

class LoginViewModel {
    private weak var coordinator: Coordinator?
    private let authUseCase: AuthUseCaseProtocol
    private let loadImageUseCase: LoadImageUseCaseProtocol
    private let loginUseCase: LoginUseCaseProtocol
    private let headerImageUrl = "https://mobilecodetest.fws.io/images/ipad.jpg"

    init(coordinator: Coordinator,
         authUseCase: AuthUseCaseProtocol,
         loadImageUseCase: LoadImageUseCaseProtocol,
         loginUseCase: LoginUseCaseProtocol) {
        self.coordinator = coordinator
        self.authUseCase = authUseCase
        self.loadImageUseCase = loadImageUseCase
        self.loginUseCase = loginUseCase
    }
}

extension LoginViewModel: ViewModelType {

    struct Input {
        /// called when a screen will Appear
        let willAppear: AnyPublisher<Void, Never>
        /// triggered when the username text changes
        let userName: AnyPublisher<String, Never>
        /// triggered when the password text changes
        let password: AnyPublisher<String, Never>
        /// triggered when login is presses
        let loginAction: AnyPublisher<Void, Never>
    }

    struct Output {
        /// send when it fetch the image header
        let headerImage: AnyPublisher<Data, Never>
        /// enable login button when there is username and password
        let enableLogin: AnyPublisher<Bool, Never>
        /// send when it's doing the login
        let isLoading: AnyPublisher<Bool, Never>
        /// send when the login failed
        let openList: AnyPublisher<Error?, Never>
    }

    func transform(input: Input) -> Output {
        let headerImage = input
            .willAppear
            .flatMap { [unowned self] _ in
                self.loadImageUseCase
                    .loadImage(for: self.headerImageUrl)
            }
            .compactMap { $0 }
            .eraseToAnyPublisher()

        let loginAccess = Publishers
            .CombineLatest(input.userName,
                           input.password)
            .map { ($0, $1) }

        let enableLogin = Publishers
            .Merge(input.willAppear.map { false },
                   loginAccess.map { !$0.isEmpty && !$1.isEmpty })
            .eraseToAnyPublisher()

        let loginResult = input.loginAction
            .map { _ in Date() }
            .combineLatest(loginAccess)
            .removeDuplicates(by: {
                $0.0 == $1.0
            })
            .map { $0.1 }
            .flatMap { [unowned self] userName, password in
                self.loginUseCase
                    .getToken(userName: userName,
                              password: password)
            }

        let openList = loginResult
            .flatMap { [weak self] result -> AnyPublisher<Error?, Never> in
                switch result {
                case .success(let authToken):
                    self?.authUseCase.setToken(authToken.token)
                    self?.coordinator?.articles()
                    return .just(nil)
                case .failure(let error):
                    return .just(error)
                }
            }
            .eraseToAnyPublisher()

        let isLoading = Publishers
            .Merge3(input.willAppear.map { false },
                    input.loginAction.map { true },
                    loginResult.map { _ in false })
            .eraseToAnyPublisher()
        
        return Output(headerImage: headerImage,
                      enableLogin: enableLogin,
                      isLoading: isLoading,
                      openList: openList)
    }
}
