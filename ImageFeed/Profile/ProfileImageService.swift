//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 23.04.2024.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService(); private init() {}
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private let queue = DispatchQueue(label: "ProfileImageServiceQueue")
    
    private(set) var avatarURL: String?
    
    func makeProfileImageRequest(for username: String) -> URLRequest? {
        guard let url = URL(string: "api.unsplash.com//users/:username") else {
            print("[ProfileImageService:makeImageProfileRequest]: AuthServiseError - invalidRequest")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = OAuth2Service.shared.oauthToken {
            request.setValue("Bearer\(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    func fetchProfileImage(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeProfileImageRequest(for: username) else {
            print("[ProfileImageService:fetchProfileImage]: AuthServiseError - invalidRequest")
            return }
        let session = URLSession.shared
        
        let task = session.objectTask(for: request) { (result: Result<UserResult, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let userResult):
                    let profileImageURL = userResult.profileImage.small
                    self.avatarURL = profileImageURL
                    completion(.success(profileImageURL))
                    self.queue.async {
                        // Notification
                        NotificationCenter.default.post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["url": profileImageURL]
                        )
                    }
                case .failure(let error):
                    completion(.failure(error))
                    print("[ProfileService:fetchProfileImage]: NetworkError - decodingError - \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}
