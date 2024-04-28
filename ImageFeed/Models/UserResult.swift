//
//  UserResult.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 23.04.2024.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage
}
struct ProfileImage: Codable {
    let small: String
}
