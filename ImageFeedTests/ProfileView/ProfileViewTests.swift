//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Екатерина Шрайнер on 02.06.2024.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    
    func testCallsAddNotification() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        presenter.addNotification()
        
        //then
        XCTAssertTrue(presenter.addNotificationCalled)
    }
    
    func testCallsUpdateProfile() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        presenter.updateProfile()
        
        //then
        XCTAssertTrue(presenter.updateProfileCalled)
    }
    
    func testCallsUpdateAvatar() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        presenter.updateAvatar()
        
        //then
        XCTAssertTrue(presenter.updateAvatarCalled)
    }
    
    func testCallsProfileLogout() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        presenter.profileLogout()
        
        //then
        XCTAssertTrue(presenter.profileLogoutCalled)
    }
    
    func testCallsUpdateProfileDetails() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        let profile = Profile(username: "ekaterina", name: "Екатерина Новикова", loginName: "@ekaterina_nov", bio: "Hello, World!")
        viewController.updateProfileDetails(profileData: profile)
        
        //then
        XCTAssertTrue(viewController.updateProfileDetailsCalled)
    }
    
    func testCallsSetUserPhoto() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        let url = Constants.defaultBaseURL
        viewController.setUserPhoto(url: url)
        
        //then
        XCTAssertTrue(viewController.setUserPhotoCalled)
    }
} 
