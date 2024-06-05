//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 23.04.2024.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    private init() {}
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private let queue = DispatchQueue(label: "ProfileImageServiceQueue")
    private var task: URLSessionTask?
    private var imageUser: String?
    private (set) var avatarURL: String?
    
    func cleanAvatarURL() {
        avatarURL = nil
    }
    
    private func makeProfileImageRequest(username: String) -> URLRequest? {
        let path = "/users/\(username)"
        guard let url = URL(string: path, relativeTo: Constants.defaultBaseURL) else {
            print("[ProfileImageService:makeProfileImageRequest]: ProfileServiceError - неверный запрос")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = OAuth2Service.shared.oauthToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    func fetchProfileImage(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        guard self.imageUser != username else {
            completion(.failure(ProfileServiceError.invalidRequest))
            print("[ProfileImageService:fetchProfileImage]: ProfileServiceError - неверный запрос")
            return
        }
        self.task?.cancel()
        self.imageUser = username
        
        guard let request = makeProfileImageRequest(username: username) else {
            print("[ProfileImageService:fetchProfileImage]: ProfileServiceError - неверный запрос")
            return }
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            
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
                    print("[ProfileImageService:fetchProfileImage]: NetworkError - ошибка декодирования")
                }
            }
            self.task = nil
            self.imageUser = nil
        }
        self.task = task
        task.resume()
    }
}
