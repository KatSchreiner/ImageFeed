//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 22.04.2024.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
  
    var name: String {
        if let firstName = firstName, let lastName = lastName {
            return "\(firstName) \(lastName)"
        } else {
            return ""
        }
    }
    
    var loginName: String {
        return "@\(username)"
    }

}
