//
//  Articles.swift
//  CodeTest
//
//  Created by Edwin Peña on 7/10/22.
//

import Foundation

struct Article {
    let id: Int
    let title: String?
    let summary: String?
    let date: String?
    let thumbnailUrl: String?
    let thumbnailTemplateUrl: String?
    let content: String?
}

extension Article: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case summary
        case date
        case thumbnailUrl = "thumbnail_url"
        case thumbnailTemplateUrl = "thumbnail_template_url"
        case content
    }
}
