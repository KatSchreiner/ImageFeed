//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 22.04.2024.
//

import Foundation

final class ProfileResult: Codable {
    var username: String
    var firstName: String?
    var lastName: String?
    var bio: String?
    var links: Links?
    
    struct Links: Codable {
        let selfURL: String
        let html: String
        let photos: String
        let likes: String
        let portfolio: String
        
        private enum CodingKeys: String, CodingKey {
            case selfURL = "self"
            case html, photos, likes, portfolio
        }
    }
}
