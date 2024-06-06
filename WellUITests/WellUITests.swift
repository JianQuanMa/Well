//
//  WellUITests.swift
//  WellUITests
//
//  Created by Jian Ma on 6/5/24.
//

import XCTest

class WellUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // Launch the app
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
        try super.tearDownWithError()
    }

    func testToggleButtonTogglesView() throws {
        // Initially, the view should be UIKit
        XCTAssertTrue(app.buttons["Switch to SwiftUI"].exists)
        
        // Tap on the toggle button
        app.buttons["Switch to SwiftUI"].tap()
        
        // After tapping, the view should switch to SwiftUI
        XCTAssertTrue(app.buttons["Switch to UIKit"].exists)
        
        // Tap on the toggle button again
        app.buttons["Switch to UIKit"].tap()
        
        // After tapping again, the view should switch back to UIKit
        XCTAssertTrue(app.buttons["Switch to SwiftUI"].exists)
    }
}

