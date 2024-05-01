//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Екатерина Шрайнер on 01.05.2024.
//

@testable import ImageFeed
import XCTest

final class ImagesListServiceTests: XCTestCase {
    func testExample() {
    }
    
    func testFetchPhotos() {
        let service = ImagesListService.shared
        guard let username = ProfileService.shared.profile?.username else { return }
            
            let expectation = self.expectation(description: "Wait for Notification")
            NotificationCenter.default.addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main) { _ in
                    expectation.fulfill()
                }
        
        service.fetchPhotosNextPage(username) { _ in }
        
            wait(for: [expectation], timeout: 10)
            
            XCTAssertEqual(service.photos.count, 10)
        }
}
