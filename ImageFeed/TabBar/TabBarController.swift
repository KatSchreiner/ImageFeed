//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 26.04.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
        guard let imagesListViewController = imagesListViewController as? ImagesListViewController else { return }
        let imagesListPresenter = ImagesListViewPresenter(view: imagesListViewController)
        imagesListViewController.presenter = imagesListPresenter
        imagesListPresenter.view = imagesListViewController
        
        let profileViewController = ProfileViewController()
        let profileViewPresenter = ProfileViewPresenter(view: profileViewController)
        profileViewController.presenter = profileViewPresenter
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
