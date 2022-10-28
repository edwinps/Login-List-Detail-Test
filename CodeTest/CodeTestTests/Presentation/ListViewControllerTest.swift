//
//  ListViewController.swift
//  CodeTestTests
//
//  Created by Edwin Peña on 9/10/22.
//

//import Foundation
//import XCTest
//@testable import CodeTest
//
//class ListViewControllerTest: XCTestCase {
//    // MARK: - System Under Test
//    private var articlesUseCase: ArticlesUseCaseMock!
//    private var loadImageUseCase: LoadImageUseCaseMock!
//    private var coordinator: CoordinatorMock!
//    private var sut: ListViewController!
//
//    // MARK: Mocks
//    private var mockViewModel: ListViewModel!
//
//    // MARK: Tests Methods
//
//    override func setUp() {
//        super.setUp()
//        coordinator = CoordinatorMock()
//        articlesUseCase = ArticlesUseCaseMock()
//        loadImageUseCase = LoadImageUseCaseMock()
//        articlesUseCase.getArticlesReturnValue = .just(.success(MockActicles.articlesMock()))
//        loadImageUseCase.loadImageForReturnValue = .just(Data())
//        mockViewModel = ListViewModel(coordinator: coordinator,
//                                      loadImageUseCase: loadImageUseCase,
//                                      articlesUseCase: articlesUseCase)
//        sut = ListViewController(viewModel: mockViewModel)
//    }
//
//    override func tearDown() {
//        sut = nil
//        mockViewModel = nil
//        super.tearDown()
//    }
//
//    func test_afterViewDidLoad() {
//        let window = UIWindow()
//        loadView(window)
//        sut.loadViewIfNeeded()
//    }
//
//    func loadView(_ window: UIWindow) {
//        window.addSubview(sut.view)
//        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
//    }
//}
