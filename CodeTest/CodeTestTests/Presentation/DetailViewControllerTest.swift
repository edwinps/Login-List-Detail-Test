//
//  DetailViewControllerTest.swift
//  CodeTestTests
//
//  Created by Edwin Peña on 9/10/22.
//

import Foundation
import XCTest
@testable import CodeTest

class DetailViewControllerTest: XCTestCase {
    // MARK: - System Under Test
    private var loadImageUseCase: LoadImageUseCaseMock!
    private var articlesUseCase: ArticlesUseCaseMock!
    private var coordinator: CoordinatorMock!
    private var sut: DetailViewController!

    // MARK: Mocks
    private var mockViewModel: DetailViewModel!

    // MARK: Tests Methods

    override func setUp() {
        super.setUp()
        coordinator = CoordinatorMock()
        loadImageUseCase = LoadImageUseCaseMock()
        articlesUseCase = ArticlesUseCaseMock()
        let article = Article(id: 1,
                              title: "title",
                              summary: "summary",
                              date: "Data",
                              thumbnailUrl: "",
                              thumbnailTemplateUrl: "",
                              content: "content")
        let articleVM = ArticleViewModel(id: 1,
                                       title: "title",
                                       summary: "summary",
                                       date: "Data",
                                       imageData: .just(Data()),
                                       content: "content")
        articlesUseCase.getArticleDetailsWithReturnValue = .just(.success(article))
        loadImageUseCase.loadImageForReturnValue = .just(Data())
        mockViewModel = DetailViewModel(coordinator: coordinator,
                                        loadImageUseCase: loadImageUseCase,
                                        articlesUseCase: articlesUseCase,
                                        article: articleVM)
        sut = DetailViewController(viewModel: mockViewModel)
    }

    override func tearDown() {
        sut = nil
        mockViewModel = nil
        super.tearDown()
    }

    func test_afterViewDidLoad() {
        let window = UIWindow()
        loadView(window)
    }

    func loadView(_ window: UIWindow) {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
}
