//
//  ViewController.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 29.02.2024.
//

import UIKit
import ProgressHUD

final class ImagesListViewController: UIViewController {
    
    // MARK: IB Outlets
    @IBOutlet weak private var tableView: UITableView!
    
    // MARK: Private Properties
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    var photos: [Photo] = []
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewAnimated()
        }
        
        ImagesListService.shared.fetchPhotosNextPage()
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

extension ImagesListViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("\(indexPath.row)") // DEL
        
        if indexPath.row + 1 == ImagesListService.shared.photos.count {
            ImagesListService.shared.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                let isLiked = self.photos[indexPath.row].isLiked
                cell.setIsLiked(isLiked)
                
                case .failure:
                   UIBlockingProgressHUD.dismiss()
                DispatchQueue.main.async {
                    AlertPresenter.showAlertError(
                        in: self,
                        title: "Что-то пошло не так(",
                        message: "Не удалось поставить лайк")
                }
            }
        }
    }
}
