//
//  AuthTokenResponse.swift
//  CodeTest
//
//  Created by Edwin Peña on 8/10/22.
//

import Foundation

struct AuthTokenDTO {
    let username: String
    let password: String
    let grantType: String
}

extension AuthTokenDTO: Encodable {
    enum CodingKeys: String, CodingKey {
        case username
        case password
        case grantType = "grant_type"
    }
}

struct AuthToken {
    let token: String
    let refreshToken: String
}

extension AuthToken: Decodable {
    enum CodingKeys: String, CodingKey {
        case token = "access_token"
        case refreshToken = "refresh_token"
    }
}
