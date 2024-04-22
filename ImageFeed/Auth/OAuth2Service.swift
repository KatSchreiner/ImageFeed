//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 07.04.2024.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    private var queue = DispatchQueue(label: "OAuth2Service_fetchOAuthToken")
    
    private var oauthToken: String? {
        get { OAuth2TokenStorage().token }
        set { OAuth2TokenStorage().token = newValue }
    }
    
    private init() {}
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            assertionFailure("Не удалось создать URLComponents")
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
            preconditionFailure("Не удалось получить URL-адрес из URLComponents")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        // Создаем серийную очередь выполнения задач
        queue.sync {
            // Проверяем, что метод вызывается на основной потоке
            assert(Thread.isMainThread)
            
            // Проверяем, что lastcode отличается от текущего кода
            guard lastCode != code else {
                completion(.failure(AuthServiseError.invalidRequest))
                return
            }
            // Отменяем предыдущую задачу
            task?.cancel()
            
            // Сохраняем текущий код в lastcode
            lastCode = code
            
            // Создаем и проверяем запрос на получение токена
            guard let request = self.makeOAuthTokenRequest(code: code) else {
                completion(.failure(AuthServiseError.invalidRequest))
                return
            }
            
            let task = self.urlSession.dataTask(with: request) { [weak self] data, response, error in
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
                                    self?.oauthToken = accessToken
                                    completion(.success(accessToken))
                                } catch {
                                    completion(.failure(NetworkError.urlSessionError))
                                    print("Ошибка декодера: \(error)")
                                }
                            } else {
                                completion(.failure(NetworkError.urlSessionError))
                            }
                        } else {
                            completion(.failure(NetworkError.httpStatusCode(statusCode)))
                            print("Ошибка кода состояния HTTP: \(statusCode)")
                        }
                    } else if let error = error {
                        completion(.failure(NetworkError.urlRequestError(error)))
                        print("Ошибка запроса URL: \(error)")
                    } else {
                        completion(.failure(NetworkError.urlSessionError))
                        print("Ошибка сеанса URL-адреса")
                    }
                    self?.task = nil // обнуляем task
                    self?.lastCode = nil // удаляем lastCode после завершения и обработки запроса
                }
            }
            
            self.task = task // сохраняем ссылку на task
            task.resume() // запускаем запрос на выполнение
        }
    }
}
enum AuthServiseError: Error {
    case invalidRequest
}
