//
//  LoginUseCase.swift
//  CodeTest
//
//  Created by Edwin Peña on 8/10/22.
//

import Foundation
import Combine

enum LoginError: Error {
    case invalidData
}

protocol LoginUseCaseProtocol {
    func getToken(userName: String,
                  password: String) -> AnyPublisher<Result<AuthToken, Error>, Never>
}

final class LoginUseCase: LoginUseCaseProtocol {

    private let networkService: NetworkServiceType

    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }

    func getToken(userName: String,
                  password: String) -> AnyPublisher<Result<AuthToken, Error>, Never> {
        let authToken = AuthTokenDTO(username: userName,
                                     password: password,
                                     grantType: "password")
        return networkService
            .request(Resource<String>
                .login(authTokenDTO: authToken))
            .map { .success($0) }
            .catch { error -> AnyPublisher<Result<AuthToken, Error>, Never> in
                    .just(.failure(LoginError.invalidData))
            }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
}

