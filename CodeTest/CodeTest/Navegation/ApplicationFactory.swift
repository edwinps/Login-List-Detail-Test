//
//  ApplicationFactory.swift
//  CodeTest
//
//  Created by Edwin Peña on 8/10/22.
//

import UIKit

/// The ApplicationComponentsFactory takes responsibity of
/// creating application components and establishing dependencies between them.
class ApplicationFactory {
    lazy var loginUseCase: LoginUseCaseProtocol = LoginUseCase(
        networkService: servicesProvider.network
    )
    
    lazy var loadImageUseCase: LoadImageUseCaseProtocol = LoadImageUseCase(
        imageLoaderService: servicesProvider.imageLoader
    )

    lazy var articlesUseCase: ArticlesUseCaseProtocol = ArticlesUseCase(
        networkService: servicesProvider.network,
        authUseCase: authUseCase
    )

    var authUseCase: AuthUseCaseProtocol = AuthUseCase()
    private let servicesProvider: ServicesProvider

    init(servicesProvider: ServicesProvider = ServicesProvider.defaultProvider()) {
        self.servicesProvider = servicesProvider
    }
}
