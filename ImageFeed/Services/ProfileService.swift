//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 22.04.2024.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private init() {}
    
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    private var dataProfile: String?

    private func makeProfileRequest() -> URLRequest? {
        let path = "/me"
        guard let url = URL(string: path, relativeTo: Constants.defaultBaseURL) else {
            print("[ProfileService:makeProfileRequest]: Не удалось создать URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = OAuth2Service.shared.oauthToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {

        assert(Thread.isMainThread)
        guard self.dataProfile != token else {
            completion(.failure(ProfileServiceError.invalidRequest))
            print("[ProfileService:fetchProfile]: ProfileServiceError - неверный запрос")
            return
        }
        self.task?.cancel()
        self.dataProfile = token
        
            guard let request = self.makeProfileRequest() else {
                completion(.failure(ProfileServiceError.invalidRequest))
                print("[ProfileService:fetchProfile]: ProfileServiceError - неверный запрос")
                return
            }
            let session = URLSession.shared
            let task = session.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
                guard let self = self else { return }
                
                DispatchQueue.main.async{
                    switch result {
                    case .success(let profileresult):
                        let profile = Profile(
                            username: profileresult.username,
                            name: "\(profileresult.firstName ?? "") \(profileresult.lastName ?? "")",
                            loginName: "@\(profileresult.username)",
                            bio: profileresult.bio
                        )
                        self.profile = profile
                        completion(.success(profile))
                    case .failure(let error):
                        completion(.failure(error))
                        print("[ProfileService:fetchProfile]: NetworkError - ошибка декодирования")
                    }
                }
                self.task = nil
                self.dataProfile = nil
            }
            self.task = task
            task.resume()
        }
}

enum ProfileServiceError: Error {
    case invalidRequest
}
