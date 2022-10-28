//
//  AuthUseCase.swift
//  CodeTest
//
//  Created by Edwin Peña on 7/10/22.
//

import Foundation

protocol AuthUseCaseProtocol {
    var token: String? { get }
    func setToken(_ token: String?)
    func deleteAuth()
}

final class AuthUseCase: AuthUseCaseProtocol {

    private let keychainHelper: KeychainProtocol
    private let service = "access-token"
    private let account = "login"

    init(keychainHelper: KeychainProtocol = KeychainHelper()) {
        self.keychainHelper = keychainHelper
    }

    var token: String? {
        keychainHelper
            .read(service: service,
                  account: account,
                  type: String.self)
    }

    func setToken(_ token: String?) {
        keychainHelper
            .save(token,
                  service: service,
                  account: account)
    }

    func deleteAuth() {
        keychainHelper
            .delete(service: service,
                    account: account)
    }
}
