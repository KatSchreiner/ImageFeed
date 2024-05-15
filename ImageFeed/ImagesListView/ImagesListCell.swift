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
    
    // MARK: Public Methods
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath, createdAt: Date?) {
        
        if let date = createdAt {
            let dateString = DateFormatters.shared.dateFormatter.string(from: date)
            dateLabel.text = dateString
        } else {
            dateLabel.text = ""
        }
        
        self.linearGradientView.linearGradient()
        
        self.setIsLiked(false)
        
        self.backgroundView = placeholderImageView
    }
    
    // MARK: Private Methods
    func setIsLiked(_ isLiked: Bool) {
        let image = isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
        likeButton.setImage(image, for: .normal)
    }
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    // MARK: Override Mhetods
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
}
