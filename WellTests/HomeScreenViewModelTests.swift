//
//  HomeScreenViewModelTests.swift
//  WellTests
//
//  Created by Jian Ma on 6/5/24.
//

import XCTest
@testable import Well // Replace with your app's module name
@MainActor
class HomeScreenViewModelTests: XCTestCase {
    
    func testViewDidLoad() {
        // Given
        let exp = expectation(description: "example")
        let sut = HomeScreenViewModel(client: .init {
            exp.fulfill()
            return .success([])
        })
        // When
        sut.onViewDidLoad()
        wait(for: [exp], timeout: 1)
        // Then
        XCTAssertEqual(sut.fetchState, .loaded(.success([])))
    }
    
    func testViewWillAppear() {
        // Given
        let exp = expectation(description: "example")
        let sut = HomeScreenViewModel(client: .init {
            exp.fulfill()
            return .success([])
        })
        // When
        sut.onAppear()
        wait(for: [exp], timeout: 1)
        // Then
        XCTAssertEqual(sut.fetchState, .loaded(.success([])))
    }
}

extension HomeScreenViewModel.FetchState: Equatable {
    public static func == (lhs: HomeScreenViewModel.FetchState, rhs: HomeScreenViewModel.FetchState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case let (.loading(message1), .loading(message2)):
            return message1 == message2
        case let (.loaded(.success(result1)), .loaded(.success(result2))):
            return result1 == result2
        default:
            return false
        }
    }
}
