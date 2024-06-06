//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Екатерина Шрайнер on 29.05.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    private let email: String = ""
    private let password: String = ""
    private let nameProfile: String = ""
    private let loginProfile: String = ""
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText(email)
        
        let keyboard = app.buttons["Done"]
        keyboard.tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText(password)
        
        keyboard.tap()
        
        let loginButton = app.buttons["Login"]
        loginButton.tap()
        
        sleep(5)
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        sleep(3)
        let tablesQuery = app.tables
        let cell = tablesQuery.cells.element(boundBy: 0)
        cell.swipeUp()
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        cellToLike.buttons["No Active"].tap()
        sleep(2)
        
        cellToLike.buttons["Active"].tap()
        sleep(2)
        
        cellToLike.tap()
        sleep(5)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButton = app.buttons["Back Button"]
        navBackButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        let avatarImage = app.images["avatar image"]
        XCTAssertTrue(avatarImage.waitForExistence(timeout: 5))
        
        XCTAssertTrue(app.staticTexts[nameProfile].exists)
        XCTAssertTrue(app.staticTexts[loginProfile].exists)
        
        app.buttons["Logout button"].tap()
        
        app.alerts["Пока, пока"].scrollViews.otherElements.buttons["Да"].tap()
    }
} 
