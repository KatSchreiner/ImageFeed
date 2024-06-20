//
//  Constants.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 06.06.2024.
//

import Foundation

enum Constants {
    static let accessKey = "Qe2ecFlpaMpcMVWDDvNLtw09w4wpsqf6LTDPBaJaEC0"
    static let secretKey = "0o8LymV_B0XRVysFyeczS4im7swpj6w7sMSuJFBmVPk"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = ["public", "read_user", "write_likes"].joined(separator: "+")
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
