//
//  Photo.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 29.04.2024.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
} 
