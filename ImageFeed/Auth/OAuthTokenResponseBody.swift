//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 07.04.2024.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken: Data
    let tokenType: String
    let scope: String
    let createdAt: Int
}
