//
//  ListViewModel.swift
//  CodeTest
//
//  Created by Edwin Peña on 8/10/22.
//

import Foundation
import Combine

enum ListState {
    case success([ArticleViewModel])
    case noResults
    case failure(Error)
}
extension ListState: Equatable {
    static func == (lhs: ListState, rhs: ListState) -> Bool {
        switch (lhs, rhs) {
        case (.success(let lhsArticles),
            .success(let rhsArticles)): return lhsArticles == rhsArticles
        case (.noResults, .noResults): return true
        case (.failure, .failure): return true
        default: return false
        }
    }
}

final class ListViewModel {
    private weak var coordinator: Coordinator?
    private let loadImageUseCase: LoadImageUseCaseProtocol
    private let articlesUseCase: ArticlesUseCaseProtocol
    private let authUseCase: AuthUseCaseProtocol

    init(coordinator: Coordinator,
         loadImageUseCase: LoadImageUseCaseProtocol,
         articlesUseCase: ArticlesUseCaseProtocol,
         authUseCase: AuthUseCaseProtocol) {
        self.coordinator = coordinator
        self.loadImageUseCase = loadImageUseCase
        self.articlesUseCase = articlesUseCase
        self.authUseCase = authUseCase
    }
}

extension ListViewModel: ViewModelType {
    struct Input {
        /// called when a screen will Appear
        let willAppear: AnyPublisher<Void, Never>
        /// trigger with a pull refresh
        let pullRefreshAction: AnyPublisher<Void, Never>
        /// called when the user selected an item from the list
        let selection: AnyPublisher<ArticleViewModel, Never>
        /// trigger with a logout button
        let logoutAction: AnyPublisher<Void, Never>
    }

    struct Output {
        /// return the list of articles
        let listState: AnyPublisher<ListState, Never>
        /// send when it's doing the login
        let isLoading: AnyPublisher<Bool, Never>
    }

    func transform(input: Input) -> Output {
        let listState = Publishers
            .Merge(input.willAppear,
                   input.pullRefreshAction)
            .flatMap { [unowned self] _ in
                self.articlesUseCase.getArticles()
            }
            .map { [unowned self] result -> ListState in
                switch result {
                case .success(let articles) where articles.isEmpty:
                    return .noResults
                case .success(let articles):
                    return .success(self.viewModels(from: articles))
                case .failure(let error):
                    if let articlesError = error as? ArticlesError {
                        switch articlesError {
                        case .expiredToken:
                            self.coordinator?.start()
                        default:
                            break
                        }
                    }
                    return .failure(error)
                }
            }
            .eraseToAnyPublisher()

        let showDetail = input.selection
            .map { [ weak self] article in
                self?.coordinator?.showDetails(for: article)
            }

        let logout = input.logoutAction
            .map { [weak self] _ in
                self?.authUseCase.deleteAuth()
                self?.coordinator?.start()
            }

        let isLoading = Publishers
            .Merge4(input.willAppear.map { true },
                    listState.map { _ in false },
                    showDetail.map { _ in false },
                    logout.map {_ in false })
            .eraseToAnyPublisher()

        return Output(listState: listState,
                      isLoading: isLoading)
    }
}

// MARK: - Inner methods

private extension ListViewModel {
    private func viewModels(from articles: [Article]) -> [ArticleViewModel] {
        return articles.map({ [unowned self] article in
            let imageData = self.loadImageUseCase
                .loadImage(for: article.thumbnailUrl)
            return ArticleViewModel(id: article.id,
                                    title: article.title,
                                    summary: article.summary,
                                    date: article.date,
                                    imageData: imageData,
                                    content: article.content)
        })
    }
}

