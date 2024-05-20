//
//  ViewController.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 29.02.2024.
//

import UIKit
import ProgressHUD

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListViewPresenterProtocol? { get set }
    var tableView: UITableView! { get set }
    func showDidTapLikeError()
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    var presenter: ImagesListViewPresenterProtocol?
    
    // MARK: IB Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Private Properties
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        presenter?.viewDidLoad()
        ImagesListService.shared.fetchPhotosNextPage()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController,
                  let indexPath = sender as? IndexPath else {
                assertionFailure("Invalid segue destination")
                return
            }
            guard let presenter = presenter else { return }
            let fullImageUrl = presenter.photos[indexPath.row].largeImageURL
            viewController.imageToURL(fullImageUrl: fullImageUrl)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter else { return 0 }
        return presenter.photos.count
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
       guard let presenter else { return CGFloat() }
       let imageSize = presenter.photos[indexPath.row].size
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
        presenter?.didTapLike(cell)
    }
    
    func showDidTapLikeError() {
        DispatchQueue.main.async {
            AlertPresenter.showAlertError(
                in: self,
                title: "Что-то пошло не так(",
                message: "Не удалось поставить лайк")
        }
    }
}
