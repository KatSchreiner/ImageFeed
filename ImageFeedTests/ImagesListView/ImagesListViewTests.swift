//
//  ImagesListViewTests.swift
//  ImageFeedTests
//
//  Created by Екатерина Шрайнер on 29.05.2024.
//
@testable import ImageFeed
import XCTest

final class ImagesListViewTests: XCTestCase {
    
    func testCallsAddNotification() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        viewController.presenter?.addNotification()
        
        //then
        XCTAssertTrue(presenter.addNotificationCalled)
    }
    
    func testCallsFetchPhotosNextPage() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        viewController.presenter?.fetchPhotosNextPage()
        
        //then
        XCTAssertTrue(presenter.fetchPhotosNextPageCalled)
    }
    
    func testCallsUpdateTableViewAnimated() {
        //given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListViewPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.view?.updateTableViewAnimated()
        
        //then
        XCTAssertTrue(viewController.updateTableViewAnimatedCalled)
    }
    
}
