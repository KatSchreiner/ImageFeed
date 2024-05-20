//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 19.05.2024.
//

import Foundation
import UIKit

protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
    func viewDidLoad()
    func updateTableViewAnimated()
    func didTapLike(_ cell: ImagesListCell)
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    init(view: ImagesListViewControllerProtocol) {
        self.view = view
    }
    var photos: [Photo] = []
    
    private var imagesListServiceObserver: NSObjectProtocol?
    private let imagesListService = ImagesListService.shared



    
    func viewDidLoad() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewAnimated()
        }
    }
    
    func updateTableViewAnimated() {
        let oldCount = self.photos.count
        let newCount = ImagesListService.shared.photos.count
        self.photos = ImagesListService.shared.photos
        if oldCount != newCount {
            DispatchQueue.main.async {
                self.view?.tableView.performBatchUpdates {
                    let indexPaths = (oldCount..<newCount).map { i in
                        IndexPath(row: i, section: 0)
                    }
                    self.view?.tableView.insertRows(at: indexPaths, with: .automatic)
                } completion: { _ in }
            }
        }
    }
    
    func didTapLike(_ cell: ImagesListCell) {
        guard let indexPath = view?.tableView.indexPath(for: cell) else { return }
        let photo = self.photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
            switch result {
            case .success(let isLiked):
                self.photos = self.imagesListService.photos
                self.photos[indexPath.row].isLiked = isLiked
                cell.setIsLiked(isLiked)
                
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.view?.showDidTapLikeError()
            }
        }
    }
}
