//
//  ViewController.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 29.02.2024.
//

import UIKit
import ProgressHUD

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListViewPresenterProtocol? { get set }
    func updateTableViewAnimated()
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    // MARK: IB Outlets
    @IBOutlet weak private var tableView: UITableView!
    
    // MARK: Public Properties
    var presenter: ImagesListViewPresenterProtocol?
    
    // MARK: Private Properties
    private let imagesListService = ImagesListService.shared
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    var photos: [Photo] = []
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ImagesListViewPresenter()
        presenter?.view = self
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        
        presenter?.addNotification()
        
        presenter?.fetchPhotosNextPage()
    }
    
    // MARK: - Overrides Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController,
                  let indexPath = sender as? IndexPath else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            let fullImageUrl = photos[indexPath.row].largeImageURL
            viewController.imageToURL(fullImageUrl: fullImageUrl)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath) as? ImagesListCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        
        let photos = ImagesListService.shared.photos
        let photo = photos[indexPath.row]
        cell.setIsLiked(photo.isLiked)
        
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: URL(string: photo.thumbImageURL)) { result in
            switch result {
            case .success(_):
                tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure(let error):
                print("[ImagesListCell:configCell]: - ошибка загрузки изображения: \(error.localizedDescription)")
            }
        }
        
        cell.configCell(for: cell, with: indexPath, createdAt: photo.createdAt)
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageSize = photos[indexPath.row].size
        let imageWidth = tableView.bounds.width - tableView.contentInset.left - tableView.contentInset.right
        let imageHeight = imageWidth * (imageSize.height / imageSize.width)
        let padding = tableView.contentInset.top + tableView.contentInset.bottom
        
        return imageHeight + padding
    }
}

// MARK: ImagesListViewController
extension ImagesListViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row + 1 == ImagesListService.shared.photos.count {
            ImagesListService.shared.fetchPhotosNextPage()
        }
    }
    
    func updateTableViewAnimated() {
        let oldCount = self.photos.count
        let newCount = ImagesListService.shared.photos.count
        self.photos = ImagesListService.shared.photos
        if oldCount != newCount {
            DispatchQueue.main.async {
                self.tableView.performBatchUpdates {
                    let indexPaths = (oldCount..<newCount).map { i in
                        IndexPath(row: i, section: 0)
                    }
                    self.tableView.insertRows(at: indexPaths, with: .automatic)
                } completion: { _ in }
            }
        }
    }
}

// MARK: ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
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
                DispatchQueue.main.async {
                    self.tapLikeShowError()
                }
            }
        }
    }
    
    func tapLikeShowError() {
        AlertPresenter.showAlertError(
            in: self,
            title: "Что-то пошло не так(",
            message: "Не удалось поставить лайк")
    }
}
