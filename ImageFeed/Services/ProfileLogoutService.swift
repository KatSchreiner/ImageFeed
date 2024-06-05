//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 12.05.2024.
//

import Foundation
import WebKit
import SwiftKeychainWrapper

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    private init() { }
    
    private let authToken = OAuth2TokenStorage()
    
    func logout() {
        cleanCookies()
        authToken.cleanToken()
        ProfileService.shared.cleanProfile()
        ProfileImageService.shared.cleanAvatarURL()
        ImagesListService.shared.cleanPhotos()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
