//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 02.03.2024.
//

import Foundation
import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    // MARK: IB Outlets
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var linearGradientView: UIView!
    
    // MARK: Public Properties
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: Private Properties
    private var controller = ImagesListViewController()
    
    // MARK: Override Mhetods       
    override func prepareForReuse() {
        super.prepareForReuse()
        // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        // fullsize
        cellImage.kf.cancelDownloadTask()
    }
    
    // MARK: Public Methods
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        // получаем название картинки по индексу
        let imageName = controller.photosName[indexPath.row]
        
        // проверяем есть UIImage с таким название
        if let image = UIImage(named: imageName) {
            self.cellImage.image = image
        } else { return }
        
        // добавляем текущую дату
        let currentDate = Date()
        let dateString = controller.dateFormatter.string(from: currentDate)
        self.dateLabel.text = dateString
        
        if indexPath.row % 2 == 0 {
            self.likeButton.setImage(UIImage(named: "Active"), for: .normal)
        } else {
            self.likeButton.setImage(UIImage(named: "No Active"), for: .normal)
        }
        
        self.linearGradientView.linearGradient()
    }
}
