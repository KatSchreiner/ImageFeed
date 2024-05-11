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
    
    // MARK: Public Properties
    var  dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }
    // создаем массив чисел и возвращаем массив строк
    let photosName: [String] = Array(0..<20).map{ "\($0)"}
    
    // MARK: Private Properties
    private var imagesListServiceObserver: NSObjectProtocol?
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var photos: [Photo] = []
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        
        // Наблюдатель для обновления таблицы при изменении данных
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
    
    // функция срабатывает когда приходит нотификация о том, что данные изменились
    func updateTableViewAnimated() {
        let oldCount = self.photos.count
        let newCount = ImagesListService.shared.photos.count
        self.photos = ImagesListService.shared.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    // определяем количество ячеек в секции таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ImagesListService.shared.photos.count
    }
    
    // возвращаем ячейку по идентификатору
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(
//            withIdentifier: ImagesListCell.reuseIdentifier,
//            for: indexPath)
//        
//        guard let imageListCell = cell as? ImagesListCell else {
//            return UITableViewCell()
//        }
//        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath) as? ImagesListCell else {
                return UITableViewCell()
        }
        cell.delegate = self // Установка делегата
        
        let photos = ImagesListService.shared.photos
            let photo = photos[indexPath.row]

            // добавляем изображение с использованием Kingfisher
            cell.cellImage.kf.setImage(
                with: URL(string: photo.thumbImageURL),
                placeholder: UIImage(named: "placeholder_image"),
            options: nil,
                progressBlock:  nil) { result in
                switch result {
                case .success(_):
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                case .failure(let error):
                    print("[ImagesListCell:configCell]: - ошибка загрузки изображения: \(error.localizedDescription)")
                }
            }
        cell.cellImage.kf.indicatorType = .activity
        
        cell.configCell(for: cell, with: indexPath)
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    
    // действия при нажатии на ячейку таблицы
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
//    динамическая высота ячейки
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       guard let image = UIImage(named: photosName[indexPath.row]) else {
           return 0
       }
       
       let imageWidth = tableView.bounds.width - tableView.contentInset.left - tableView.contentInset.right
       let imageHeight = imageWidth * (image.size.height / image.size.width)
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
        // Обработка действия нажатия на "лайк" в ячейке
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
              
        UIBlockingProgressHUD.show()
        
        ImagesListService.shared.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
            switch result {
            case .success:
                self.photos[indexPath.row].isLiked = !self.photos[indexPath.row].isLiked
                DispatchQueue.main.async {
                    cell.setIsLiked(self.photos[indexPath.row].isLiked)
                }
                
                // Уберём лоадер
                UIBlockingProgressHUD.dismiss()
            case .failure:
                // Уберём лоадер
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
    
//    private func showError() {
//            let alert = UIAlertController(title: "Ошибка", message: "Что-то пошло не так. Попробовать ещё раз?", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Не надо", style: .cancel, handler: nil))
//            alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { _ in
//                // Retry loading image here
//            }))
//            
//            present(alert, animated: true, completion: nil)
//        }
}
