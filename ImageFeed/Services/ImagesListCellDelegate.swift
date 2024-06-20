//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 13.05.2024.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
} 
