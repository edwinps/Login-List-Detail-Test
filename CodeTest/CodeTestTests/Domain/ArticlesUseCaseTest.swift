//
//  ArticlesUseCaseTest.swift
//  CodeTestTests
//
//  Created by Edwin Peña on 9/10/22.
//

import Foundation
import XCTest
import Combine
@testable import CodeTest

class ArticlesUseCaseTest: XCTestCase {
    private var sut: ArticlesUseCase!
    private var networkService: NetworkServiceMock!
    private var authUseCase: AuthUseCaseMock!
    private var disposables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        networkService = NetworkServiceMock()
        authUseCase = AuthUseCaseMock()
        authUseCase.token = "token"
        sut = ArticlesUseCase(networkService: networkService,
                              authUseCase: authUseCase)
    }

    override func tearDown() {
        sut = nil
        networkService = nil
        authUseCase = nil
        super.tearDown()
    }

    func test_getArticles_Succeed() {
        // Given
        var result: Result<[Article], Error>!
        let expectation = expectation(description: "Articles")
        let articles = [Article].loadFromFile("Articles.json")
        networkService.responses["/api/v1/articles"] = articles

        // When
        sut.getArticles()
            .sink { value in
            result = value
            expectation.fulfill()
        }.store(in: &disposables)

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        guard case .success = result! else {
            XCTFail()
            return
        }
        XCTAssert(networkService.requestCalled)
    }

    func test_getArticlesFailes_onError() {
        // Given
        var result: Result<[Article], Error>!
        let expectation = expectation(description: "Articles")
        networkService.responses["/api/v1/articles"] = NetworkError.invalidResponse

        // When
        sut.getArticles()
        .sink { value in
            result = value
            expectation.fulfill()
        }.store(in: &disposables)

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        switch result! {
        case .failure(let error):
            guard let articlesError = error as? ArticlesError,
               case .generic = articlesError else {
                XCTFail()
                return
            }
        default:
            XCTFail()
        }
        XCTAssert(networkService.requestCalled)
    }

    func test_getArticlesFailes_onUnAuthorizedError() {
        // Given
        var result: Result<[Article], Error>!
        let expectation = expectation(description: "Articles")
        networkService.responses["/api/v1/articles"] = NetworkError.unAuthorized

        // When
        sut.getArticles()
        .sink { value in
            result = value
            expectation.fulfill()
        }.store(in: &disposables)

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        switch result! {
        case .failure(let error):
            guard let articlesError = error as? ArticlesError,
               case .expiredToken = articlesError else {
                XCTFail()
                return
            }
        default:
            XCTFail()
        }
        XCTAssert(networkService.requestCalled)
    }

    func test_getArticleDetails_Succeed() {
        // Given
        var result: Result<Article, Error>!
        let expectation = expectation(description: "Article")
        let article = Article.loadFromFile("Article.json")
        networkService.responses["/api/v1/articles/1"] = article

        // When
        sut.getArticleDetails(with: 1)
            .sink { value in
            result = value
            expectation.fulfill()
        }.store(in: &disposables)

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        guard case .success = result! else {
            XCTFail()
            return
        }
        XCTAssert(networkService.requestCalled)
    }

    func test_getArticleDetails_onUnAuthorizedError() {
        // Given
        var result: Result<Article, Error>!
        let expectation = expectation(description: "Article")
        networkService.responses["/api/v1/articles/1"] = NetworkError.unAuthorized

        // When
        sut.getArticleDetails(with: 1)
        .sink { value in
            result = value
            expectation.fulfill()
        }.store(in: &disposables)

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        switch result! {
        case .failure(let error):
            guard let articlesError = error as? ArticlesError,
               case .expiredToken = articlesError else {
                XCTFail()
                return
            }
        default:
            XCTFail()
        }
        XCTAssert(networkService.requestCalled)
    }

    func test_getArticleDetails_onError() {
        // Given
        var result: Result<Article, Error>!
        let expectation = expectation(description: "Article")
        networkService.responses["/api/v1/articles/1"] = NetworkError.invalidResponse

        // When
        sut.getArticleDetails(with: 1)
        .sink { value in
            result = value
            expectation.fulfill()
        }.store(in: &disposables)

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        switch result! {
        case .failure(let error):
            guard let articlesError = error as? ArticlesError,
               case .generic = articlesError else {
                XCTFail()
                return
            }
        default:
            XCTFail()
        }
        XCTAssert(networkService.requestCalled)
    }
}
