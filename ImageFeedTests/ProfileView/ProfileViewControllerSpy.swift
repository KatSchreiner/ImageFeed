//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Екатерина Шрайнер on 29.05.2024.
//

import Foundation
import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfilePresenterProtocol?
    var updateProfileDetailsCalled: Bool = false
    var setUserPhotoCalled: Bool = false
    
    func updateProfileDetails(profileData: ImageFeed.Profile) {
        updateProfileDetailsCalled = true
    }
    
    func setUserPhoto(url: URL) {
        setUserPhotoCalled = true
    }
} 
