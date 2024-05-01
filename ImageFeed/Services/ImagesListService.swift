//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 29.04.2024.
//

import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    //private init() {}
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var lastRequest: URL?
    
    private func makePhotosRequest(username: String) -> URLRequest? {
        let path = "/users/\(username)/collections"
        guard let url = URL(string: path, relativeTo: Constants.defaultBaseURL) else { 
            assertionFailure("[ImagesListService:makePhotosRequest]: ImagesListServiceError - неверный запрос")
            return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = OAuth2Service.shared.oauthToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let lastRequest = lastRequest, url == lastRequest {
            assertionFailure("[ImagesListService:makePhotosRequest]: ImagesListServiceError - - повторный запрос")
            return nil
        }
        
        self.lastRequest = url
        return request
    }
    
    func fetchPhotosNextPage(_ username: String, completion: @escaping (Result<Photo, Error>) -> Void) {
        
        let nextPage = (lastLoadedPage ?? 0) + 1 // Вычисляем номер следующей страницы
        
        guard let request = makePhotosRequest(username: username) else {
            assertionFailure("[ImagesListService:fetchPhotosNextPage]: ImagesListServiceError - неверный запрос")
            return }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<PhotoResult, Error>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let photoResult):
                    let newPhotos = Photo(
                        id: photoResult.id,
                        size: CGSize(width: photoResult.width, height: photoResult.height),
                        createdAt: photoResult.createdAt,
                        welcomeDescription: photoResult.description,
                        thumbImageURL: photoResult.urls.thumb,
                        largeImageURL: photoResult.urls.full,
                        isLiked: photoResult.likedByUser
                    )
                    
                    self.photos.append(newPhotos)
                    self.lastLoadedPage = nextPage
                    completion(.success(newPhotos))

                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["url": newPhotos]
                    )

                case .failure(let error):
                    completion(.failure(error))
                    print("[ImagesListService:fetchPhotosNextPage]: NetworkError - ошибка декодирования")
                }
            }
            
        }
        task.resume()
    }
}

enum ImagesListServiceError: Error {
    case invalidRequest
}
