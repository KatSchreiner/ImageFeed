//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 07.04.2024.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private var oauthToken: String? {
        get { OAuth2TokenStorage().token }
        set { OAuth2TokenStorage().token = newValue }
    }
    
    private init() {}
    
    func makeOAuthTokenRequest(code: String) -> URLRequest {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            preconditionFailure("Failed to create URLComponents")
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            preconditionFailure("Failed to get URL from URLComponents")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let session = URLSession.shared
        let request = makeOAuthTokenRequest(code: code)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse {
                    let statusCode = response.statusCode
                    
                    if 200 ..< 300 ~= statusCode {
                        if let data = data {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            do {
                                let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                                let accessToken = response.accessToken
                                self.oauthToken = accessToken
                                completion(.success(accessToken))
                            } catch {
                                completion(.failure(NetworkError.urlSessionError))
                                print("Decoder error: \(error)")
                            }
                        } else {
                            completion(.failure(NetworkError.urlSessionError))
                        }
                    } else {
                        completion(.failure(NetworkError.httpStatusCode(statusCode)))
                        print("HTTP status code error: \(statusCode)")
                    }
                } else if let error = error {
                    completion(.failure(NetworkError.urlRequestError(error)))
                    print("URL request error: \(error)")
                } else {
                    completion(.failure(NetworkError.urlSessionError))
                    print("URL session error")
                }
            }
        }
        task.resume()
    }
}


