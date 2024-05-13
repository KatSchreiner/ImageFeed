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
    
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: Private Properties
    private var imagesListViewController = ImagesListViewController()
    
    // MARK: Public Methods
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        let currentDate = Date()
        let dateString = imagesListViewController.dateFormatter.string(from: currentDate)
        self.dateLabel.text = dateString
        
        self.linearGradientView.linearGradient()
        
        self.setIsLiked(false)
    }
    // MARK: Private Methods
    func setIsLiked(_ isLiked: Bool) {
        if isLiked {
            likeButton.setImage(UIImage(named: "Active"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "No Active"), for: .normal)
        }
        
    }
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    // MARK: Override Mhetods
    override func prepareForReuse() {
        super.prepareForReuse()
        // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        cellImage.kf.cancelDownloadTask()
    }
}
