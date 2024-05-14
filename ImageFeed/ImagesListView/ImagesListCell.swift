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
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        
        return formatter
    }()
    
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
        guard let createdAt = createdAt else {
            assertionFailure("[ImagesListCell: configCell]: невозможно загрузить дату")
            return
        }
        
        let dateString = ImagesListCell.dateFormatter.string(from: createdAt)
        dateLabel.text = dateString
        
        self.linearGradientView.linearGradient()
        
        self.setIsLiked(false)
        
        self.backgroundView = placeholderImageView
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
        cellImage.kf.cancelDownloadTask()
    }
}
