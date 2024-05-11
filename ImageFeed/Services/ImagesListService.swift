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
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var isLoaded = false // флаг для отслеживания загрузки
    
    private func makePhotosRequest() -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/photos") else {
            assertionFailure("[ImagesListService:makePhotosRequest]: ImagesListServiceError - неверный запрос")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        guard let token = OAuth2Service.shared.oauthToken  else {
            assertionFailure("[ImagesListService:makePhotosRequest]: ImagesListServiceError - ошибка авторизации")
            return nil
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }

    func fetchPhotosNextPage() {
        // Проверяем, идет ли уже загрузка
        guard !isLoaded else {
            return
        }
        
        isLoaded = true
        
        let nextPage = lastLoadedPage.map { $0 + 1 } ?? 1
        
        guard let request = makePhotosRequest() else {
            assertionFailure("[ImagesListService:fetchPhotosNextPage]: ImagesListServiceError - неверный запрос")
            isLoaded = false
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let photoResults):
                    let newPhotos = photoResults.map { photoResult in
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"

//                        let createdAt = photoResult.createdAt != nil ? dateFormatter.date(from: photoResult.createdAt ?? "") : nil
                        
                        let createdAtString = photoResult.createdAt
                        let createdAt = dateFormatter.date(from: createdAtString ?? "")
                        
                        return Photo(
                            id: photoResult.id,
                            size: CGSize(width: photoResult.width, height: photoResult.height),
                            createdAt: createdAt,
                            welcomeDescription: photoResult.description,
                            thumbImageURL: photoResult.urls.thumb,
                            largeImageURL: photoResult.urls.full,
                            isLiked: photoResult.likedByUser)
                    }
                    
                    self.photos.append(contentsOf: newPhotos)
                    self.lastLoadedPage = nextPage
                    
                    // Отправка уведомления о том, что данные были обновлены
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: nil
                    )
                    self.isLoaded = false // Установка флага загрузки в false после обновления данных
                case .failure(let error):
                    print("[ImagesListService:fetchPhotosNextPage]: NetworkError - ошибка декодирования")
                    self.isLoaded = false // Установка флага загрузки в false в случае ошибки
                }
            }
        }
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "https://api.unsplash.com/photos/\(photoId)/like") else {
            completion(.failure(ImagesListServiceError.invalidRequest))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        
        guard let token = OAuth2Service.shared.oauthToken else {
            completion(.failure(ImagesListServiceError.invalidRequest))
            return
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: !photo.isLiked
                    )
                    self.photos[index] = newPhoto
                    
                    completion(.success(()))
                } else {
                    completion(.failure(ImagesListServiceError.photoNotFound))
                }
            }
        }
        task.resume()
    }
}

enum ImagesListServiceError: Error {
    case invalidRequest
    case photoNotFound
}
