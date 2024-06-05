//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 03.04.2024.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case decodingError
}

extension URLSession {
    func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                    print("Ошиюка HTTP статус кода: \(statusCode)")
                }
            } else if let error = error {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
                print("Ошибка запроса: \(error.localizedDescription)")
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
                print("Ошибка URLSession: не было получено данных или ответа: \(NetworkError.urlSessionError.localizedDescription)")
            }
        })
        return task
    }
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decodedObject = try decoder.decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch {
                    completion(.failure(NetworkError.decodingError))
                    print("Ошибка декодирования: \(error.localizedDescription), Данные: \(String(data: data, encoding: .utf8) ?? "")")
                }
            case .failure(_):
                completion(.failure(NetworkError.urlSessionError))
                print("Ошибка URLSession: не было получено данных или ответа: \(NetworkError.urlSessionError.localizedDescription)")
                
            }
        }
        return task
    }
}
