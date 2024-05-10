//
//  ViewController.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 29.02.2024.
//

import UIKit

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
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        let photos = ImagesListService.shared.photos
            let photo = photos[indexPath.row]

            // добавляем изображение с использованием Kingfisher
            imageListCell.cellImage.kf.setImage(
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
        imageListCell.cellImage.kf.indicatorType = .activity
        
        imageListCell.configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
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

