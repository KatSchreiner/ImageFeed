//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Екатерина Шрайнер on 28.05.2024.
//

import ImageFeed
import Foundation

final class ProfileViewPresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    
    var addNotificationCalled: Bool = false
    var updateProfileCalled: Bool = false
    var updateAvatarCalled: Bool = false
    var profileLogoutCalled: Bool = false
    
    func addNotification() {
        addNotificationCalled = true
    }
    
    func updateProfile() {
        updateProfileCalled = true
    }
    
    func updateAvatar() {
        updateAvatarCalled = true
    }
    
    func profileLogout() {
        profileLogoutCalled = true
    }
}
