//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 07.04.2024.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "acces token"
        case tokenType = "token type"
        case scope
        case createdAt = "created_at"
    }
}