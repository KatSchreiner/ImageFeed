//
//  Constants.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 30.03.2024.
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

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String

    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            authURLString: Constants.unsplashAuthorizeURLString,
            defaultBaseURL: Constants.defaultBaseURL)
    }
}
