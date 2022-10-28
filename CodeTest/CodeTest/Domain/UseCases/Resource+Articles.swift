//
//  Resource+Articles.swift
//  CodeTest
//
//  Created by Edwin Peña on 6/10/22.
//

import Foundation

extension Resource {
    static func articles(token: String?) -> Resource<[Article]> {
        let url = Environment.apiUrl.appendingPathComponent("/api/v1/articles")
        return Resource<[Article]>(url: url,
                                   parameters: [:],
                                   token: token)
    }

    static func details(token: String?, articleID: Int) -> Resource<Article> {
        let url = Environment.apiUrl.appendingPathComponent("/api/v1/articles/\(articleID)")
        return Resource<Article>(url: url,
                                 parameters: [:],
                                 token: token)
    }
}
