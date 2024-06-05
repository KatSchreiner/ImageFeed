//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 18.05.2024.
//

import Foundation
import UIKit

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    
    func addNotification()
    func updateProfile()
    func updateAvatar()
    func profileLogout()
}

final class ProfileViewPresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    func addNotification() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            updateAvatar()
        }
    }
    
    func updateProfile() {
        guard let profile = ProfileService.shared.profile else { return }
        view?.updateProfileDetails(profileData: profile)
    }
    
    func updateAvatar() {
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL) else { return }
        view?.setUserPhoto(url: url)
    }
    
    func profileLogout() {
        ProfileLogoutService.shared.logout()
    }
}
