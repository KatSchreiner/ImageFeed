//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 29.04.2024.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt: Date?
    let width: Int
    let height: Int
    let likes: Int
    let likedByUser: Bool
    let description: String
    let urls: URLs
}

struct URLs: Codable {
    let raw: String
    let full: String
    let thumb: String
}
