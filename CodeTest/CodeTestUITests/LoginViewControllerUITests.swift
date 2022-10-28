//
//  LoginViewControllerUITests.swift
//  CodeTestUITests
//
//  Created by Edwin Peña on 11/10/22.
//

import XCTest

class LoginViewControllerUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws { }

    func testLoginButton_enable() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        let userName = app.textFields["userName"]
        let password = app.secureTextFields["password"]
        let login = app.buttons["login"]

        XCTAssertFalse(userName.isSelected)
        XCTAssertFalse(password.isSelected)
        XCTAssertFalse(login.isEnabled)

        userName.tap()
        userName.typeText("code")
        XCTAssertEqual(userName.value as? String, "code")

        password.tap()
        password.typeText("test")
        XCTAssertEqual(userName.value as? String, "code")

        XCTAssertTrue(login.isEnabled)
    }

    func testLoginAction_returnError() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        let userName = app.textFields["userName"]
        let password = app.secureTextFields["password"]
        let login = app.buttons["login"]

        userName.tap()
        userName.typeText("code")
        password.tap()
        password.typeText("pass")

        login.tap()
        let alertTitle = app.staticTexts["alert title"]
        XCTAssertEqual(alertTitle.label,
                       "There was a problem, please try again")
        XCTAssert(!app.images["alert image"].screenshot().pngRepresentation.isEmpty)
    }

    func testLoginAction_successful() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        let userName = app.textFields["userName"]
        let password = app.secureTextFields["password"]
        let login = app.buttons["login"]

        userName.tap()
        userName.typeText("code")
        password.tap()
        password.typeText("test")

        login.tap()

        XCTAssert(app.navigationBars["ListViewController"].waitForExistence(timeout: 2))
    }
}
