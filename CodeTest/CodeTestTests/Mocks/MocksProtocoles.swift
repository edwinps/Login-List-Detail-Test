//
//  MocksProtocoles.swift
//  CodeTestTests
//
//  Created by Edwin Peña on 9/10/22.
//

import Foundation
import XCTest
import Combine
@testable import CodeTest

class ImageLoaderServiceMock: ImageLoaderServiceType {

    //MARK: - loadImage
    var loadImageFromCalled = false
    var loadImageFromReturnValue: AnyPublisher<Data?, Never>!
    var loadImageFromClosure: ((URL) -> AnyPublisher<Data?, Never>)?

    func loadImage(from url: URL) -> AnyPublisher<Data?, Never> {
        loadImageFromCalled = true
        return loadImageFromClosure.map({ $0(url) }) ?? loadImageFromReturnValue
    }
}

class CoordinatorMock: Coordinator {

    //MARK: - Coordinator
    var startCalled = false
    var articlesCalled = false
    var showDetailsForCalled = false
    var showDetailsForReturnValue: ArticleViewModel!

    func start() {
        startCalled = true
    }

    func articles() {
        articlesCalled = true
    }
    func showDetails(for article: ArticleViewModel) {
        showDetailsForCalled = true
    }
}

class AuthUseCaseMock: AuthUseCaseProtocol {
    var token: String?

    // MARK: - setToken

    var setTokenCalled = false

    func setToken(_ token: String?) {
        setTokenCalled = true
    }

    var deleteAuthCalled = false
    func deleteAuth() {
        deleteAuthCalled = true
    }
}

class KeychainMock<T>: KeychainProtocol where T: Decodable, T : Encodable {
    var saveItemCalled = false
    func save<T>(_ item: T, service: String, account: String) where T: Decodable, T : Encodable {
        saveItemCalled = true
    }

    var readItemReturn: T?
    var readItemCalled = false
    func read<T>(service: String, account: String, type: T.Type) -> T? where T: Decodable, T : Encodable {
        readItemCalled = true
        return readItemReturn as? T
    }

    var deleteServiceCalled = false
    func delete(service: String, account: String) {
        deleteServiceCalled = true
    }
}

class LoadImageUseCaseMock: LoadImageUseCaseProtocol {

    // MARK: - loadImage

    var loadImageForCalled = false
    var loadImageForReturnValue: AnyPublisher<Data?, Never>!

    func loadImage(for url: String?) -> AnyPublisher<Data?, Never> {
        loadImageForCalled = true
        return loadImageForReturnValue
    }

}

class LoginUseCaseMock: LoginUseCaseProtocol {

    // MARK: - getToken
    var getTokenUserNamePasswordCalled = false
    var getTokenUserNamePasswordReturnValue: AnyPublisher<Result<AuthToken, Error>, Never>!

    func getToken(userName: String, password: String) -> AnyPublisher<Result<AuthToken, Error>, Never> {
        getTokenUserNamePasswordCalled = true
        return getTokenUserNamePasswordReturnValue
    }

}

class ArticlesUseCaseMock: ArticlesUseCaseProtocol {

    // MARK: - getArticles

    var getArticlesCalled = false
    var getArticlesReturnValue: AnyPublisher<Result<[Article], Error>, Never>!

    func getArticles() -> AnyPublisher<Result<[Article], Error>, Never> {
        getArticlesCalled = true
        return getArticlesReturnValue
    }

    // MARK: - getArticleDetails

    var getArticleDetailsWithCalled = false
    var getArticleDetailsWithReturnValue: AnyPublisher<Result<Article, Error>, Never>!

    func getArticleDetails(with id: Int) -> AnyPublisher<Result<Article, Error>, Never> {
        getArticleDetailsWithCalled = true
        return getArticleDetailsWithReturnValue
    }
}

class NetworkServiceMock: NetworkServiceType {
    var requestCalled = false
    var responses = [String: Any]()

    func request<T>(_ resource: Resource<T>) -> AnyPublisher<T, Error> {
        requestCalled = true
        if let response = responses[resource.url.path] as? T {
            return .just(response)
        } else if let error = responses[resource.url.path] as? NetworkError {
            return .fail(error)
        } else {
            return .fail(NetworkError.invalidRequest)
        }
    }
}

