//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 22.04.2024.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService(); private init() {}
    private let urlSession = URLSession.shared
    
    private func createURL() -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/me") else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let token = OAuth2Service.shared.oauthToken
        request.setValue("Bearer \(String(describing: token))", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        guard let request = createURL() else {
            completion(.failure(AuthServiseError.invalidRequest))
            return
        }
        let taskProfile = urlSession.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let profileResult = try decoder.decode(ProfileResult.self, from: data)
                    let profile = Profile(
                        username: profileResult.username,
                        name: profileResult.name,
                        loginName: profileResult.loginName,
                        bio: profileResult.bio
                    )
                    completion(.success(profile))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        taskProfile.resume()
    }
    
}
