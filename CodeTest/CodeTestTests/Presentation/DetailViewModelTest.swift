//
//  DetailViewModelTest.swift
//  CodeTestTests
//
//  Created by Edwin Peña on 9/10/22.
//

import Foundation
import XCTest
import Combine
@testable import CodeTest

class DetailViewModelTest: XCTestCase {
    private var sut: DetailViewModel!
    private var loadImageUseCase: LoadImageUseCaseMock!
    private var articlesUseCase: ArticlesUseCaseMock!
    private var coordinator: CoordinatorMock!
    private var disposables = Set<AnyCancellable>()
    private let article: Article = Article.loadFromFile("Article.json")

    override func setUp() {
        super.setUp()
        coordinator = CoordinatorMock()
        loadImageUseCase = LoadImageUseCaseMock()
        articlesUseCase = ArticlesUseCaseMock()
        sut = DetailViewModel(coordinator: coordinator,
                              loadImageUseCase: loadImageUseCase,
                              articlesUseCase: articlesUseCase,
                              article: MockActicles.articleViewModelMock())
    }

    override func tearDown() {
        sut = nil
        coordinator = nil
        loadImageUseCase = nil
        articlesUseCase = nil
        super.tearDown()
    }

    private func createInput(
        willAppear: AnyPublisher<Void, Never> = .empty()
    )
        -> DetailViewModel.Input
    {
        return DetailViewModel
            .Input(willAppear: willAppear)
    }

    func test_viewWillAppear_returnViewModel() {
        // Given
        let expectation = expectation(description: "Detail ViewModel")
        let trigger = PassthroughSubject<Void, Never>()
        let input = createInput(willAppear: trigger.eraseToAnyPublisher())
        let output = sut.transform(input: input)
        var actualsModel: DetailState?
        let article = MockActicles.articleMock()
        let expectedViewModel = MockActicles.articleViewModelMock()
        loadImageUseCase.loadImageForReturnValue = .just(Data())
        articlesUseCase.getArticleDetailsWithReturnValue = .just(.success(article))

        // When
        output.detailState
            .removeDuplicates()
            .sink { state in
            actualsModel = state
            expectation.fulfill()
        }.store(in: &disposables)

        trigger.send(())

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(actualsModel)
        XCTAssert(loadImageUseCase.loadImageForCalled)
        XCTAssert(articlesUseCase.getArticleDetailsWithCalled)
        XCTAssertEqual(actualsModel!, .success(expectedViewModel))
    }
    
    func test_viewWillAppear_getArticle_expiredToken() {
        // Given
        let expectation = expectation(description: "Detail ViewModel")
        let trigger = PassthroughSubject<Void, Never>()
        let input = createInput(willAppear: trigger.eraseToAnyPublisher())
        let output = sut.transform(input: input)
        var actualsModel: DetailState?
        articlesUseCase.getArticleDetailsWithReturnValue = .just(.failure(ArticlesError.expiredToken))

        // When
        output.detailState
            .drop(while: { state in
                if case .success = state {
                    return true
                }
                return false
            })
            .first()
            .sink { state in
            actualsModel = state
            expectation.fulfill()
        }.store(in: &disposables)

        trigger.send(())

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(actualsModel)
        XCTAssert(articlesUseCase.getArticleDetailsWithCalled)
        XCTAssert(coordinator.startCalled)
        XCTAssertEqual(actualsModel!, .failure(ArticlesError.expiredToken))
    }

    func test_viewWillAppear_getArticle_onError() {
        // Given
        let expectation = expectation(description: "Detail ViewModel")
        let trigger = PassthroughSubject<Void, Never>()
        let input = createInput(willAppear: trigger.eraseToAnyPublisher())
        let output = sut.transform(input: input)
        var actualsModel: DetailState?
        articlesUseCase.getArticleDetailsWithReturnValue = .just(.failure(NetworkError.invalidResponse))

        // When
        output.detailState
            .drop(while: { state in
                if case .success = state {
                    return true
                }
                return false
            })
            .first()
            .sink { state in
            actualsModel = state
            expectation.fulfill()
        }.store(in: &disposables)

        trigger.send(())

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(actualsModel)
        XCTAssert(articlesUseCase.getArticleDetailsWithCalled)
        XCTAssertEqual(actualsModel!, .failure(NetworkError.invalidResponse))
    }
}


