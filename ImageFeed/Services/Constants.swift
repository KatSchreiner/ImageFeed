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
    static let accessScope = ["scope1", "scope2", "scope3"].joined(separator: "+")
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
}
