//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 08.04.2024.
//

import Foundation

final class OAuth2TokenStorage {
    private var token = "Bearer Token"
    private let defaults = UserDefaults.standard
    
    var accessToken: String? {
        get {
            return defaults.string(forKey: token)
        }
        set {
            defaults.set(newValue, forKey: token)
        }
    }
}
