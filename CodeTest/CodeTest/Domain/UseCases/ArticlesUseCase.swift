//
//  ArticlesUseCase.swift
//  CodeTest
//
//  Created by Edwin Peña on 7/10/22.
//

import Foundation
import Combine

enum ArticlesError: Error {
    case expiredToken
    case generic
}

protocol ArticlesUseCaseProtocol {
    /// get list of articles
    func getArticles() -> AnyPublisher<Result<[Article], Error>, Never>

    /// Fetches details for article with specified id
    func getArticleDetails(with id: Int) -> AnyPublisher<Result<Article, Error>, Never>
}

final class ArticlesUseCase: ArticlesUseCaseProtocol {
    private let networkService: NetworkServiceType
    private let authUseCase: AuthUseCaseProtocol

    init(networkService: NetworkServiceType,
         authUseCase: AuthUseCaseProtocol) {
        self.networkService = networkService
        self.authUseCase = authUseCase
    }

    func getArticles() -> AnyPublisher<Result<[Article], Error>, Never> {
        return networkService
            .request(Resource<[Article]>.articles(token: self.authUseCase.token))
            .map { .success($0) }
            .catch { [unowned self] error -> AnyPublisher<Result<[Article], Error>, Never> in
                    .just(.failure(self.handleError(error: error)))
            }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }

    func getArticleDetails(with id: Int) -> AnyPublisher<Result<Article, Error>, Never> {
        return networkService
            .request(Resource<Article>.details(token: self.authUseCase.token, articleID: id))
            .map { .success($0) }
            .catch { [unowned self] error -> AnyPublisher<Result<Article, Error>, Never> in
                    .just(.failure(handleError(error: error)))
            }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
}

private extension ArticlesUseCase {
    func handleError(error: Error) -> ArticlesError {
        guard let networkError = error as? NetworkError else {
            return ArticlesError.generic
        }
        guard case .unAuthorized = networkError else {
            return ArticlesError.generic
        }
        return ArticlesError.expiredToken
    }
}

