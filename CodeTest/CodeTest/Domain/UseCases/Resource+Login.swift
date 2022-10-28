//
//  Resource+Login.swift
//  CodeTest
//
//  Created by Edwin Peña on 6/10/22.
//

import Foundation

extension Resource {
    static func login(authTokenDTO: AuthTokenDTO) -> Resource<AuthToken> {
        let url = Environment.apiUrl.appendingPathComponent("/auth/token")
        let body = try? JSONEncoder().encode(authTokenDTO)
        return Resource<AuthToken>(url: url,
                                           parameters: [:],
                                           body: body,
                                           method: .post)
    }
}
