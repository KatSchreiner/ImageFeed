//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 29.04.2024.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
}

struct UrlsResult: Codable {
    let full: String
    let thumb: String
}
