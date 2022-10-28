//
//  ApplicationFactoryTest.swift
//  CodeTestTests
//
//  Created by Edwin Peña on 9/10/22.
//

import Foundation
@testable import CodeTest

class ApplicationFactoryMock: ApplicationFactory {
     override var loginUseCase: LoginUseCaseProtocol {
        get { return LoginUseCaseMock() }
        set { super.loginUseCase = newValue }
    }

    override var loadImageUseCase: LoadImageUseCaseProtocol {
       get { return LoadImageUseCaseMock() }
       set { super.loadImageUseCase = newValue }
   }

    override var articlesUseCase: ArticlesUseCaseProtocol {
       get { return ArticlesUseCaseMock() }
       set { super.articlesUseCase = newValue }
   }

    override var authUseCase: AuthUseCaseProtocol {
       get { return AuthUseCaseMock() }
       set { super.authUseCase = newValue }
   }
}
