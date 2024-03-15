//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 15.03.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    @IBOutlet private weak var avatarImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var loginLabel: UILabel!
    
    @IBOutlet private weak var logoutButton: UIButton!
    
    
    @IBAction private func tapLogoutButton(_ sender: Any) {
    }
}
