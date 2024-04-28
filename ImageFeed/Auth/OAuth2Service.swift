//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 07.04.2024.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service(); private init() {}
    
    private var task: URLSessionTask?
    private var lastCode: String?
    private var queue = DispatchQueue(label: "OAuth2Service_fetchOAuthToken")
    
    var oauthToken: String? {
        get { OAuth2TokenStorage().token }
        set { OAuth2TokenStorage().token = newValue }
    }
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            print("[OAuth2Service:makeOAuthTokenRequest]: Не удалось создать URLComponents")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            print("[OAuth2Service:makeOAuthTokenRequest]: Не удалось получить URL-адрес из URLComponents")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        UIBlockingProgressHUD.show()
        queue.sync {
            assert(Thread.isMainThread)
            guard self.lastCode != code else {
                completion(.failure(AuthServiseError.invalidRequest))
                print("[OAuth2Service:fetchOAuthToken]: AuthServiseError - invalidRequest")
                return
            }
            self.task?.cancel()
            self.lastCode = code
            
            guard let request = self.makeOAuthTokenRequest(code: code) else {
                completion(.failure(AuthServiseError.invalidRequest))
                print("[OAuth2Service:fetchOAuthToken]: AuthServiseError - invalidRequest")
                return
            }
            let session = URLSession.shared
            let task = session.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
                UIBlockingProgressHUD.dismiss()
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        let accessToken = response.accessToken
                        self?.oauthToken = accessToken
                        completion(.success(accessToken))
                    case .failure(let error):
                        completion(.failure(NetworkError.urlSessionError.localizedDescription as! Error))
                        print("[OAuth2Service:fetchOAuthToken]: NetworkError - decodingError")
                    }
                }
                self?.task = nil
                self?.lastCode = nil
            }
            self.task = task
            task.resume()
        }
    }
}
enum AuthServiseError: Error {
    case invalidRequest
}
