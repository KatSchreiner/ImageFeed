//
//  LikeResult.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 13.05.2024.
//

import Foundation

struct LikeResult: Codable {
    let photo: likedImage
}
struct likedImage: Codable {
    let likedByUser: Bool
}
