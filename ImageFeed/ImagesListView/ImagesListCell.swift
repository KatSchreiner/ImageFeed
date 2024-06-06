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
    private var createdAt: Date?
    private let placeholderImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "placeholder"))
        imageView.contentMode = .center
        return imageView
    }()
    
    // MARK: Override Mhetods
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    // MARK: - IB Actions
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    // MARK: Public Methods
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath, createdAt: Date?) {
        
        if let date = createdAt {
            dateLabel.text = formatDate(date)
        } else {
            dateLabel.text = ""
        }
        
        self.linearGradientView.linearGradient()
        
        self.backgroundView = placeholderImageView
    }
    
    // MARK: Private Methods
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let image = isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
        
        likeButton.setImage(image, for: .normal)
        
        likeButton.accessibilityIdentifier = isLiked ? "Active" : "No Active"
    }
} 
