//
//  MockLoginViewModel.swift
//  CodeTestTests
//
//  Created by Edwin Peña on 11/10/22.
//

import Foundation
@testable import CodeTest

class MockLoginViewModel: LoginViewModel {
    var authUseCase: AuthUseCaseMock!
    var loadImageUseCase: LoadImageUseCaseMock!
    var loginUseCase: LoginUseCaseMock!
    var coordinator: CoordinatorMock!

    init() {
        coordinator = CoordinatorMock()
        authUseCase = AuthUseCaseMock()
        loadImageUseCase = LoadImageUseCaseMock()
        loginUseCase = LoginUseCaseMock()
        super.init(coordinator: coordinator,
                   authUseCase: authUseCase,
                   loadImageUseCase: loadImageUseCase,
                   loginUseCase: loginUseCase)
    }
}
