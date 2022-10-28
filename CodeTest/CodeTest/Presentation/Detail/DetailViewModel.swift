//
//  DetailViewModel.swift
//  CodeTest
//
//  Created by Edwin Peña on 8/10/22.
//

import Foundation
import Combine

enum DetailState {
    case success(ArticleViewModel)
    case failure(Error)
}

extension DetailState: Equatable {
    static func == (lhs: DetailState, rhs: DetailState) -> Bool {
        switch (lhs, rhs) {
        case (.success(let lhsArticle),
            .success(let rhsArticle)): return lhsArticle == rhsArticle
        case (.failure, .failure): return true
        default: return false
        }
    }
}

final class DetailViewModel {
    private weak var coordinator: Coordinator?
    private let loadImageUseCase: LoadImageUseCaseProtocol
    private let articlesUseCase: ArticlesUseCaseProtocol
    private let article: ArticleViewModel

    init(coordinator: Coordinator,
         loadImageUseCase: LoadImageUseCaseProtocol,
         articlesUseCase: ArticlesUseCaseProtocol,
         article: ArticleViewModel) {
        self.coordinator = coordinator
        self.loadImageUseCase = loadImageUseCase
        self.articlesUseCase = articlesUseCase
        self.article = article
    }
}

extension DetailViewModel: ViewModelType {
    struct Input {
        /// called when a screen will Appear
        let willAppear: AnyPublisher<Void, Never>
    }

    struct Output {
        /// return the list of articles
        let detailState: AnyPublisher<DetailState, Never>
    }

    func transform(input: Input) -> Output {

        let details = input.willAppear
            .flatMap { [unowned self] _ in
                self.articlesUseCase.getArticleDetails(with: self.article.id)
            }
            .map { [unowned self] result -> DetailState in
                switch result {
                case .success(let article):
                    return .success(self.viewModel(from: article))
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

        let initModel = input.willAppear
            .map { [unowned self] _  -> DetailState in
                    .success(self.article)
            }
            .eraseToAnyPublisher()

        let detailState = Publishers
            .Merge(initModel,
                   details)
            .eraseToAnyPublisher()

        return Output(detailState: detailState)
    }
}

// MARK: - Inner methods

private extension DetailViewModel {
    private func viewModel(from article: Article) -> ArticleViewModel {
        let imageData = self.loadImageUseCase
            .loadImage(for: article.thumbnailUrl)
        return ArticleViewModel(id: article.id,
                                title: article.title,
                                summary: article.summary,
                                date: article.date,
                                imageData: imageData,
                                content: article.content)
    }
}
