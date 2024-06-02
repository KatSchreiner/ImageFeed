//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Екатерина Шрайнер on 29.05.2024.
//

import Foundation
import ImageFeed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: (any ImageFeed.ImagesListViewPresenterProtocol)?
    var updateTableViewAnimatedCalled: Bool = false
    
    func updateTableViewAnimated() {
        updateTableViewAnimatedCalled = true
    }
}
