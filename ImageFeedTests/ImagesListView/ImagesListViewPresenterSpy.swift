//
//  ImagesListViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Екатерина Шрайнер on 29.05.2024.
//

import Foundation
import ImageFeed

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    var view: ImageFeed.ImagesListViewControllerProtocol?
    
    var addNotificationCalled: Bool = false
    var fetchPhotosNextPageCalled: Bool = false
    
    func addNotification() {
        addNotificationCalled = true
    }
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }
} 
