//
//  MockActicles.swift
//  CodeTestTests
//
//  Created by Edwin Peña on 9/10/22.
//

import Foundation
@testable import CodeTest

enum MockActicles {
    static func articlesMock() -> [Article] {
        return [Article].loadFromFile("Articles.json")
    }

    static func articlesViewModelMock() -> [ArticleViewModel] {
        return articlesViewModelMock(articlesMock())
    }

    static func articleMock() -> Article {
        return Article.loadFromFile("Article.json")
    }

    static func articleViewModelMock() -> ArticleViewModel {
        return articleViewModelMock(articleMock())
    }

    private static func articlesViewModelMock(_ articles: [Article]) -> [ArticleViewModel]{
        return articles.map({ article in
            ArticleViewModel(id: article.id,
                             title: article.title,
                             summary: article.summary,
                             date: article.date,
                             imageData: .just(Data()),
                             content: article.content)
        })
    }

    private static func articleViewModelMock(_ article: Article) -> ArticleViewModel {
        ArticleViewModel(id: article.id,
                         title: article.title,
                         summary: article.summary,
                         date: article.date,
                         imageData: .just(Data()),
                         content: article.content)
    }
}
