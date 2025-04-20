//
//  UserDefaultsManagerTests.swift
//  CoffeeOrderAppTests
//
//  Created by Mine Rala on 20.04.2025.
//

import XCTest
@testable import CoffeeOrderApp


final class UserDefaultsManagerTests: XCTestCase {
    var mockUserDefaultsManager: MockUserDefaultsManager!

    override func setUp() {
        super.setUp()
        mockUserDefaultsManager = MockUserDefaultsManager()
    }

    override func tearDown() {
        mockUserDefaultsManager = nil
        super.tearDown()
    }

    func testSaveCartItems_SavesItemsCorrectly() {
        // Given:
        let item1 = CartItem(id: 1, name: "Coffee", price: 5.0, quantity: 2)
        let item2 = CartItem(id: 2, name: "Tea", price: 3.0, quantity: 1)
        let items = [item1, item2]

        // When
        mockUserDefaultsManager.saveCartItems(items)

        // Then
        XCTAssertEqual(mockUserDefaultsManager.cartItems.count, 2)
        XCTAssertEqual(mockUserDefaultsManager.cartItems[0].name, "Coffee")
        XCTAssertEqual(mockUserDefaultsManager.cartItems[1].name, "Tea")
        XCTAssertEqual(mockUserDefaultsManager.cartItems[0].quantity, 2)
        XCTAssertEqual(mockUserDefaultsManager.cartItems[1].quantity, 1)
    }

    func testLoadCartItems_ReturnsSavedItems() {
        // Given
        let item1 = CartItem(id: 1, name: "Coffee", price: 5.0, quantity: 2)
        let item2 = CartItem(id: 2, name: "Tea", price: 3.0, quantity: 1)
        let items = [item1, item2]
        mockUserDefaultsManager.saveCartItems(items)

        // When
        let loadedItems = mockUserDefaultsManager.loadCartItems()

        // Then
        XCTAssertEqual(loadedItems?.count, 2)
        XCTAssertEqual(loadedItems?[0].name, "Coffee")
        XCTAssertEqual(loadedItems?[1].name, "Tea")
        XCTAssertEqual(loadedItems?[0].quantity, 2)
        XCTAssertEqual(loadedItems?[1].quantity, 1)
    }

    func testRemoveItem_RemovesItemCorrectly() {
        // Given
        let item1 = CartItem(id: 1, name: "Coffee", price: 5.0, quantity: 2)
        let item2 = CartItem(id: 2, name: "Tea", price: 3.0, quantity: 1)
        let items = [item1, item2]
        mockUserDefaultsManager.saveCartItems(items)

        // When
        mockUserDefaultsManager.removeItem(at: 0)

        // Then
        XCTAssertEqual(mockUserDefaultsManager.cartItems.count, 1)
        XCTAssertEqual(mockUserDefaultsManager.cartItems[0].name, "Tea")
        XCTAssertEqual(mockUserDefaultsManager.cartItems[0].quantity, 1)
    }

    func testIsEmpty_ReturnsCorrectResult() {
        // Given
        XCTAssertTrue(mockUserDefaultsManager.isEmpty())

        // When
        let item = CartItem(id: 1, name: "Coffee", price: 5.0, quantity: 2)
        mockUserDefaultsManager.saveCartItems([item])

        // Then
        XCTAssertFalse(mockUserDefaultsManager.isEmpty())
    }

    func testClearAllItems_ClearsAllItems() {
        // Given
        let item1 = CartItem(id: 1, name: "Coffee", price: 5.0, quantity: 2)
        let item2 = CartItem(id: 2, name: "Tea", price: 3.0, quantity: 1)
        mockUserDefaultsManager.saveCartItems([item1, item2])

        // When
        mockUserDefaultsManager.clearAllItems()

        // Then
        XCTAssertTrue(mockUserDefaultsManager.isEmpty())
    }
}
