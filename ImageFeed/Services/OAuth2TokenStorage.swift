//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 08.04.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let bearerTokenKey = "bearer_token"
    let keychain = KeychainWrapper.standard
    
    var token: String? {
        get {
            return keychain.string(forKey: bearerTokenKey)
        }
        set {
            if let newToken = newValue {
                keychain.set(newToken, forKey: bearerTokenKey)
            } else {
                keychain.removeObject(forKey: bearerTokenKey)
            }
        }
    }
    
    func cleanToken() {
        KeychainWrapper.standard.removeObject(forKey: bearerTokenKey)
    }
} 
