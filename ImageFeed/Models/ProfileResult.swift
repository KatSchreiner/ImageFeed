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
}
