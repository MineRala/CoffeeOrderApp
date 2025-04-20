//
//  DetailViewModelTests.swift
//  CoffeeOrderAppTests
//
//  Created by Mine Rala on 20.04.2025.
//

import XCTest
import Combine
@testable import CoffeeOrderApp

final class DetailViewModelTests: XCTestCase {
    var viewModel: DetailViewModel!
    var mockUserDefaultsManager: MockUserDefaultsManager!
    var mockCacheManager: MockCacheManager!
    var mockMenuItem: MenuItem!

    override func setUp() {
        super.setUp()
        mockUserDefaultsManager = MockUserDefaultsManager()
        mockCacheManager = MockCacheManager()

        mockMenuItem = MenuItem(id: 1, name: "Espresso", category: "Hot Drinks", price: 5.0, imageURL: "")

        viewModel = DetailViewModel(menuItem: mockMenuItem, userDefaultsManager: mockUserDefaultsManager, cacheManager: mockCacheManager)
    }

    override func tearDown() {
        viewModel = nil
        mockUserDefaultsManager = nil
        mockCacheManager = nil
        mockMenuItem = nil
        super.tearDown()
    }

    func testIncreaseQuantity() {
        // When
        viewModel.increaseQuantity()

        // Then
        XCTAssertEqual(viewModel.getQuantitityCount(), 2)
    }

    func testDecreaseQuantity() {
        // When
        viewModel.decreaseQuantitiy()

        // Then
        XCTAssertEqual(viewModel.getQuantitityCount(), 0)
    }

    func testGetTotalPrice() {
        // Given
        viewModel.increaseQuantity()

        // When
        let totalPrice = viewModel.getTotalPrice()

        // Then
        XCTAssertEqual(totalPrice, 10.0) // 5.0 * 2 = 10.0
    }

    func testAddToCart() {
        // Given
        let initialCartItemCount = mockUserDefaultsManager.cartItems.count

        // When
        viewModel.addToCart()

        // Then
        XCTAssertEqual(mockUserDefaultsManager.cartItems.count, initialCartItemCount + 1)

        let cartItem = mockUserDefaultsManager.cartItems.first!
        XCTAssertEqual(cartItem.id, mockMenuItem.id)
        XCTAssertEqual(cartItem.name, mockMenuItem.name)
        XCTAssertEqual(cartItem.price, mockMenuItem.price)
        XCTAssertEqual(cartItem.quantity, viewModel.getQuantitityCount())
    }

    func testPopVCPublisher() {
        // Given
        let expectation = self.expectation(description: "Pop VC Publisher triggered")
        var receivedValue: Void?

        // When
        let cancellable = viewModel.popVCPublisher.sink { value in
            receivedValue = value
            expectation.fulfill()
        }

        viewModel.addToCart()

        // Then
        wait(for: [expectation], timeout: 10)

        XCTAssertNotNil(receivedValue)

        // Cleanup
        cancellable.cancel()
    }


    func testIsQuantityGraterThanOne() {
        // Given
        viewModel.increaseQuantity()

        // When
        let result = viewModel.isQuantityGraterThanOne()

        // Then
        XCTAssertTrue(result)
    }

    func testNotificationPostedWhenAddToCart() {
        // Given
        let notificationExpectation = expectation(description: "Notification posted for cart update")

        let observer = NotificationCenter.default.addObserver(forName: .cartUpdated, object: nil, queue: nil) { notification in
            notificationExpectation.fulfill()
        }

        // When
        viewModel.addToCart()

        // Then
        wait(for: [notificationExpectation], timeout: 1)

        NotificationCenter.default.removeObserver(observer, name: .cartUpdated, object: nil)
    }



    // MARK: - Helper
    private var cancellables = Set<AnyCancellable>()
}

