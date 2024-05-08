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
    
    private func makePhotosRequest(page: Int = 1, perPage: Int = 10) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/photos") else {
            return nil
        }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(perPage))
        ]
        guard let url = components?.url else {
            assertionFailure("[ImagesListService:makePhotosRequest]: ImagesListServiceError - неверный запрос")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = OAuth2Service.shared.oauthToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }

    func fetchPhotosNextPage(completion: @escaping (Result<Photo, Error>) -> Void) {
        guard !isLoaded else {
            print("Загрузка уже выполняется")
            return }
        isLoaded = true // устанавливаем флаг загрузки
        let nextPage = lastLoadedPage.map { $0 + 1 } ?? 1
        guard let request = makePhotosRequest(page: nextPage, perPage: 10) else { return }
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<PhotoResult, Error>) in
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
                    self.photos.append(newPhoto)
                    self.lastLoadedPage = nextPage
                    completion(.success(newPhoto))
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["photo": newPhoto] // Добавляем информацию о новой фотографии в userInfo
                    )
                case .failure(let error):
                    completion(.failure(error))
                    print("[ImagesListService:fetchPhotosNextPage]: NetworkError - ошибка декодирования")
                }
                self.isLoaded = false // Сбрасываем флаг загрузки после получения данных
            }
        }
        task.resume()
    }
}

enum ImagesListServiceError: Error {
    case invalidRequest
}
