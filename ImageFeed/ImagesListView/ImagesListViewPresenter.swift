//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 19.05.2024.
//

import Foundation
import UIKit

public protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func addNotification()
    func fetchPhotosNextPage()
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    
    private var imagesListServiceObserver: NSObjectProtocol?
    
    func addNotification() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            view?.updateTableViewAnimated()
        }
    }
    
    func fetchPhotosNextPage() {
        ImagesListService.shared.fetchPhotosNextPage()
    }
} 
