//
//  NetworkManagerTests.swift
//  CoffeeOrderAppTests
//
//  Created by Mine Rala on 20.04.2025.
//

import XCTest
@testable import CoffeeOrderApp

final class NetworkManagerTests: XCTestCase {

    var mockNetworkManager: MockNetworkManager!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
    }

    override func tearDown() {
        mockNetworkManager = nil
        super.tearDown()
    }

    func testLoadLocalJSON_Successful() {
        // Given
        let filename = "menuItem"
        mockNetworkManager.shouldReturnError = false

        // When
        mockNetworkManager.loadLocalJSON(filename: filename, type: MenuItem.self) { result in
            // Then
            switch result {
            case .success(let menuItem):
                XCTAssertEqual(menuItem.id, 1)
                XCTAssertEqual(menuItem.name, "Coffee")
                XCTAssertEqual(menuItem.category, "Hot Drinks")
                XCTAssertEqual(menuItem.price, 5.0)
                XCTAssertEqual(menuItem.imageURL, "coffee_image_url")
            case .failure:
                XCTFail("Expected success, but got failure")
            }
        }
    }

    func testLoadLocalJSON_Failure() {
        // Given
        let filename = "menuItem"
        mockNetworkManager.shouldReturnError = true

        // When
        mockNetworkManager.loadLocalJSON(filename: filename, type: MenuItem.self) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error, .invalidData)
            }
        }
    }
}

