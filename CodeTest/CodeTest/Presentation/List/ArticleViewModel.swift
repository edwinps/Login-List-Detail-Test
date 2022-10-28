//
//  ArticleViewModel.swift
//  CodeTest
//
//  Created by Edwin Peña on 8/10/22.
//

import Foundation
import Combine

struct ArticleViewModel {
    let id: Int
    let title: String?
    let summary: String?
    let date: String?
    let imageData: AnyPublisher<Data?, Never>
    let content: String?
}

extension ArticleViewModel: Hashable {
    static func == (lhs: ArticleViewModel, rhs: ArticleViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
