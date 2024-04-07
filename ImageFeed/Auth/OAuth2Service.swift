//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 07.04.2024.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    init() {}
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://unsplash.com") else { return nil }
        guard let url = URL(
             string: "/oauth/token"
             + "?client_id=\(Constants.accessKey)"
             + "&&client_secret=\(Constants.secretKey)"
             + "&&redirect_uri=\(Constants.redirectURI)"
             + "&&code=\(code)"
             + "&&grant_type=authorization_code",
             relativeTo: baseURL
        ) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
     }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else { return }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                let statusCode = response.statusCode
                if 200..<300 ~= statusCode {
                    guard let data = data else { return }
                    do {
                        let response = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(response.accessToken))
                        }
                    } catch {
                        print("Failed decode response body: \(error)")
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.httpStatusCode(statusCode)))
                    }
                    print("HTTP status code error: \(statusCode)")
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.urlRequestError(error)))
                }
                print("URL request error: \(error)")
            } else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.urlSessionError))
                }
                print("URL session error")
            }
        }
        task.resume()
    }
}


