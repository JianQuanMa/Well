//
//  ContainerViewControllerTests.swift
//  WellTests
//
//  Created by Jian Ma on 6/5/24.
//

import XCTest
@testable import Well
import SwiftUI

class ContainerViewControllerTests: XCTestCase {

    var sut: ContainerViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ContainerViewController()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testInitialViewControllerIsUIKit() throws {
        XCTAssertFalse(sut.isShowingSwiftUI)
        XCTAssertTrue(sut.currentViewController is UINavigationController)
        XCTAssertEqual(sut.toggleButton.title(for: .normal), "Switch to SwiftUI")
    }

    func testToggleToSwiftUI() throws {
        sut.toggleView()
        
        XCTAssertTrue(sut.isShowingSwiftUI)
        XCTAssertTrue(sut.currentViewController is UIHostingController<PokemonListView>)
        XCTAssertEqual(sut.toggleButton.title(for: .normal), "Switch to UIKit")
    }

    func testToggleToUIKit() throws {
        // First, toggle to SwiftUI
        sut.toggleView()
        // Then, toggle back to UIKit
        sut.toggleView()
        
        XCTAssertFalse(sut.isShowingSwiftUI)
        XCTAssertTrue(sut.currentViewController is UINavigationController)
        XCTAssertEqual(sut.toggleButton.title(for: .normal), "Switch to SwiftUI")
    }
    
    func testTransitionToViewController() {
        let dummyVC = UIViewController()
        sut.transition(to: dummyVC)
        
        XCTAssertEqual(sut.currentViewController, dummyVC)
        XCTAssertTrue(sut.view.subviews.contains(dummyVC.view))
    }
}

