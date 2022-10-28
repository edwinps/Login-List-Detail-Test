//
//  ListViewControllerUITests.swift
//  CodeTestUITests
//
//  Created by Edwin Peña on 11/10/22.
//

import XCTest

class ListViewControllerUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws { }

    func testLoginButton_enable() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
//        let nav = app.navigationBars["ListViewController"]
//        XCTAssert(nav.waitForExistence(timeout: 20))
//        listviewcontrollerNavigationBar.staticTexts["Articles"].tap()
//        listviewcontrollerNavigationBar.buttons["LOGOUT"].tap()
        

    }
}
