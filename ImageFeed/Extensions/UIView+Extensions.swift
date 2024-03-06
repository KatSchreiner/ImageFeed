//
//  UIView+Extensions.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 05.03.2024.
//

import Foundation
import UIKit

extension UIView {
    func linearGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 0.00).cgColor, UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 0.20).cgColor]
        gradientLayer.cornerRadius = layer.cornerRadius
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
