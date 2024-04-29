//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 29.04.2024.
//

import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    private init() {}
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private var lastLoadedPage: Int?
    
    private (set) var photos: [Photo] = []
    
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
        return request
    }
    
    func fetchPhotosNextPage(_ username: String, completion: @escaping (Result<PhotoResult, Error>) -> Void) {
        // Здесь получим страницу номер 1, если ещё не загружали ничего,
            // и следующую страницу (на единицу больше), если есть предыдущая загруженная страница
        guard let request = makePhotosRequest(username: username) else { 
            assertionFailure("[ImagesListService:fetchPhotosNextPage]: ImagesListServiceError - неверный запрос")
            return }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<PhotoResult, Error>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let photoResult):
                    let newPhoto = Photo(
                        id: photoResult.id,
                        size: CGSize(width: photoResult.width, height: photoResult.height),
                        createdAt: photoResult.createdAt,
                        welcomeDescription: photoResult.description,
                        thumbImageURL: photoResult.urls.thumb,
                        largeImageURL: photoResult.urls.full,
                        isLiked: photoResult.likedByUser
                    )
                    
                    DispatchQueue.main.async {
                        self.photos.append(newPhoto)
                        
                        // обновляем текущую страницу
                        self.lastLoadedPage = nextPage
                        
                        completion(.success(photoResult))
                        
                        NotificationCenter.default.post(
                            name: ImagesListService.didChangeNotification,
                            object: self
                        )
                    }
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
