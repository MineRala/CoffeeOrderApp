//
//  CartViewModelTests.swift
//  CoffeeOrderAppTests
//
//  Created by Mine Rala on 20.04.2025.
//

import XCTest
@testable import CoffeeOrderApp

final class CartViewModelTests: XCTestCase {

    var viewModel: CartViewModel!
    var mockUserDefaultsManager: MockUserDefaultsManager!
    var mockDelegate: MockCartViewModelDelegate!

    override func setUp() {
        super.setUp()

        mockUserDefaultsManager = MockUserDefaultsManager()
        mockDelegate = MockCartViewModelDelegate()

        viewModel = CartViewModel(userDefaultsManager: mockUserDefaultsManager)
        viewModel.delegate = mockDelegate
    }

    override func tearDown() {
        viewModel = nil
        mockUserDefaultsManager = nil
        mockDelegate = nil
        super.tearDown()
    }

    func testLoadCartItems_ValidItems() {
        // Given
        let cartItems: [CartItem] = [
            CartItem(id: 1, name: "Espresso", price: 5.0, quantity: 2),
            CartItem(id: 2, name: "Latte", price: 4.5, quantity: 1)
        ]
        mockUserDefaultsManager.saveCartItems(cartItems)

        // When
        viewModel.loadCardItems()

        // Then
        XCTAssertEqual(viewModel.cartItemsCount, 2, "Cart items count should be equal to 2.")
        XCTAssertTrue(mockDelegate.updateVisibiltyStateCalled, "Delegate method updateVisibiltyState should be called.")
        XCTAssertTrue(mockDelegate.reloadDataCalled, "Delegate method reloadData should be called.")
        XCTAssertTrue(mockDelegate.setTotalPriceLabelCalled, "Delegate method setTotalPriceLabel should be called.")
    }

    func testLoadCartItems_EmptyCart() {
        // Given
        mockUserDefaultsManager.clearAllItems()

        // When
        viewModel.loadCardItems()

        // Then
        XCTAssertEqual(viewModel.cartItemsCount, 0, "Cart items count should be 0 for empty cart.")
        XCTAssertTrue(mockDelegate.updateVisibiltyStateCalled, "Delegate method updateVisibiltyState should be called.")
        XCTAssertTrue(mockDelegate.reloadDataCalled, "Delegate method reloadData should be called.")
        XCTAssertTrue(mockDelegate.setTotalPriceLabelCalled, "Delegate method setTotalPriceLabel should be called.")
    }

    func testDeleteItem() {
        // Given
        let cartItems: [CartItem] = [
            CartItem(id: 1, name: "Espresso", price: 5.0, quantity: 2)
        ]
        mockUserDefaultsManager.saveCartItems(cartItems)
        viewModel.loadCardItems()

        // When
        viewModel.deleteItem(at: 0)

        // Then
        XCTAssertEqual(viewModel.cartItemsCount, 0, "Cart items count should be 0 after deleting the item.")
        XCTAssertTrue(mockDelegate.reloadDataCalled, "Delegate method reloadData should be called.")
        XCTAssertTrue(mockDelegate.updateVisibiltyStateCalled, "Delegate method updateVisibiltyState should be called.")
        XCTAssertTrue(mockDelegate.setTotalPriceLabelCalled, "Delegate method setTotalPriceLabel should be called.")
    }

    func testOrderButtonTapped() {
        // Given
        let cartItems: [CartItem] = [
            CartItem(id: 1, name: "Espresso", price: 5.0, quantity: 2)
        ]
        mockUserDefaultsManager.saveCartItems(cartItems)
        viewModel.loadCardItems()

        // When
        viewModel.orderButtonTapped()

        // Then
        XCTAssertEqual(viewModel.cartItemsCount, 0, "Cart items count should be 0 after order is placed.")
        XCTAssertTrue(mockDelegate.reloadDataCalled, "Delegate method reloadData should be called.")
        XCTAssertTrue(mockDelegate.updateVisibiltyStateCalled, "Delegate method updateVisibiltyState should be called.")
        XCTAssertTrue(mockDelegate.setTotalPriceLabelCalled, "Delegate method setTotalPriceLabel should be called.")
    }

    func testIsEmptyCart() {
        // Given
        let cartItems: [CartItem] = [
            CartItem(id: 1, name: "Espresso", price: 5.0, quantity: 2)
        ]
        mockUserDefaultsManager.saveCartItems(cartItems)

        // When
        viewModel.loadCardItems()

        let isEmpty = viewModel.isEmptyCardItems()

        // Then
        XCTAssertFalse(isEmpty, "Cart should not be empty when items are present.")
    }


    func testIsEmptyCart_Empty() {
        // Given
        mockUserDefaultsManager.clearAllItems()

        // When
        let isEmpty = viewModel.isEmptyCardItems()

        // Then
        XCTAssertTrue(isEmpty, "Cart should be empty when there are no items.")
    }
}
