//
//  ListViewModelTest.swift
//  CodeTestTests
//
//  Created by Edwin Peña on 9/10/22.
//

import Foundation
import XCTest
import Combine
@testable import CodeTest

class ListViewModelTest: XCTestCase {
    private var sut: ListViewModel!
    private var articlesUseCase: ArticlesUseCaseMock!
    private var loadImageUseCase: LoadImageUseCaseMock!
    private var coordinator: CoordinatorMock!
    private var authUseCase: AuthUseCaseMock!
    private var disposables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        coordinator = CoordinatorMock()
        articlesUseCase = ArticlesUseCaseMock()
        loadImageUseCase = LoadImageUseCaseMock()
        authUseCase = AuthUseCaseMock()
        sut = ListViewModel(coordinator: coordinator,
                            loadImageUseCase: loadImageUseCase,
                            articlesUseCase: articlesUseCase,
                            authUseCase: authUseCase)
    }

    override func tearDown() {
        sut = nil
        coordinator = nil
        articlesUseCase = nil
        loadImageUseCase = nil
        authUseCase = nil
        super.tearDown()
    }

    private func createInput(
        willAppear: AnyPublisher<Void, Never> = .empty(),
        pullRefreshAction: AnyPublisher<Void, Never> = .empty(),
        selection: AnyPublisher<ArticleViewModel, Never> = .empty(),
        logoutAction: AnyPublisher<Void, Never> = .empty()
    )
        -> ListViewModel.Input
    {
        return ListViewModel
            .Input(willAppear: willAppear,
                   pullRefreshAction: pullRefreshAction,
                   selection: selection,
                   logoutAction: logoutAction)
    }

    func test_viewWillAppear_getArticlesSuccess() {
        // Given
        let expectation = expectation(description: "list State")
        let trigger = PassthroughSubject<Void, Never>()
        let input = createInput(willAppear: trigger.eraseToAnyPublisher())
        let output = sut.transform(input: input)
        var actualsModel: ListState?
        let articles = MockActicles.articlesMock()
        let expectedViewModels = MockActicles.articlesViewModelMock()
        articlesUseCase.getArticlesReturnValue = .just(.success(articles))
        loadImageUseCase.loadImageForReturnValue = .just(Data())

        // When
        output.listState.sink { state in
            actualsModel = state
            expectation.fulfill()
        }.store(in: &disposables)

        trigger.send(())

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(actualsModel)
        XCTAssert(articlesUseCase.getArticlesCalled)
        XCTAssertEqual(actualsModel!, .success(expectedViewModels))
    }

    func test_viewWillAppear_getArticles_hasErrorState() {
        // Given
        let expectation = expectation(description: "list State")
        let trigger = PassthroughSubject<Void, Never>()
        let input = createInput(willAppear: trigger.eraseToAnyPublisher())
        let output = sut.transform(input: input)
        var actualsModel: ListState?
        articlesUseCase.getArticlesReturnValue = .just(.failure(NetworkError.invalidResponse))

        // When
        output.listState.sink { state in
            actualsModel = state
            expectation.fulfill()
        }.store(in: &disposables)

        trigger.send(())

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(actualsModel)
        XCTAssert(articlesUseCase.getArticlesCalled)
        XCTAssertEqual(actualsModel!, .failure(NetworkError.invalidResponse))
    }

    func test_viewWillAppear_getArticles_expiredToken() {
        // Given
        let expectation = expectation(description: "list State")
        let trigger = PassthroughSubject<Void, Never>()
        let input = createInput(willAppear: trigger.eraseToAnyPublisher())
        let output = sut.transform(input: input)
        var actualsModel: ListState?
        articlesUseCase.getArticlesReturnValue = .just(.failure(ArticlesError.expiredToken))

        // When
        output.listState.sink { state in
            actualsModel = state
            expectation.fulfill()
        }.store(in: &disposables)

        trigger.send(())

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(actualsModel)
        XCTAssert(articlesUseCase.getArticlesCalled)
        XCTAssert(coordinator.startCalled)
        XCTAssertEqual(actualsModel!, .failure(ArticlesError.expiredToken))
    }

    func test_viewWillAppear_getArticles_noResults() {
        // Given
        let expectation = expectation(description: "list State")
        let trigger = PassthroughSubject<Void, Never>()
        let input = createInput(willAppear: trigger.eraseToAnyPublisher())
        let output = sut.transform(input: input)
        var actualsModel: ListState?
        articlesUseCase.getArticlesReturnValue = .just(.success([]))

        // When
        output.listState.sink { state in
            actualsModel = state
            expectation.fulfill()
        }.store(in: &disposables)

        trigger.send(())

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(actualsModel)
        XCTAssert(articlesUseCase.getArticlesCalled)
        XCTAssertEqual(actualsModel!, .noResults)
    }

    func test_selectArticle_showDetail() {
        // Given
        let expectation = expectation(description: "show Detail")
        let trigger = PassthroughSubject<ArticleViewModel, Never>()
        let input = createInput(selection: trigger.eraseToAnyPublisher())
        let output = sut.transform(input: input)
        let viewModel = MockActicles.articleViewModelMock()

        // When
        output.isLoading.sink { _ in
            expectation.fulfill()
        }.store(in: &disposables)

        trigger.send(viewModel)

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssert(coordinator.showDetailsForCalled)
    }

    func test_logout_showLogin() {
        // Given
        let expectation = expectation(description: "show Login")
        let trigger = PassthroughSubject<Void, Never>()
        let input = createInput(logoutAction: trigger.eraseToAnyPublisher())
        let output = sut.transform(input: input)

        // When
        output.isLoading.sink { _ in
            expectation.fulfill()
        }.store(in: &disposables)

        trigger.send(())

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssert(coordinator.startCalled)
        XCTAssert(authUseCase.deleteAuthCalled)
    }
}
