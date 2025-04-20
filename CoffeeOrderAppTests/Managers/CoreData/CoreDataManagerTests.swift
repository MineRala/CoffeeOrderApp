//
//  CoreDataManagerTests.swift
//  CoffeeOrderAppTests
//
//  Created by Mine Rala on 20.04.2025.
//

import XCTest
@testable import CoffeeOrderApp

final class CoreDataManagerTests: XCTestCase {
    var mockCoreDataManager: MockCoreDataManager!

    override func setUp() {
        super.setUp()
        mockCoreDataManager = MockCoreDataManager()
    }

    override func tearDown() {
        mockCoreDataManager = nil
        super.tearDown()
    }

    func testSaveFavorite_SavesItemCorrectly() {
        // Given
        let item = MenuItem(id: 1, name: "Coffee", category: "Beverage", price: 5.0, imageURL: "coffee_image_url")

        // When
        mockCoreDataManager.saveFavorite(item: item)

        // Then
        XCTAssertEqual(mockCoreDataManager.favorites.count, 1)
        XCTAssertEqual(mockCoreDataManager.favorites[0].name, "Coffee")
        XCTAssertEqual(mockCoreDataManager.favorites[0].category, "Beverage")
        XCTAssertEqual(mockCoreDataManager.favorites[0].price, 5.0)
    }

    func testRemoveFavorite_RemovesItemCorrectly() {
        // Given
        let item = MenuItem(id: 1, name: "Coffee", category: "Beverage", price: 5.0, imageURL: "coffee_image_url")
        mockCoreDataManager.saveFavorite(item: item)

        // When
        mockCoreDataManager.removeFavorite(id: 1)

        // Then
        XCTAssertTrue(mockCoreDataManager.favorites.isEmpty)
    }

    func testIsFavorite_ReturnsTrueIfItemIsFavorite() {
        // Given
        let item = MenuItem(id: 1, name: "Coffee", category: "Beverage", price: 5.0, imageURL: "coffee_image_url")
        mockCoreDataManager.saveFavorite(item: item)

        // When
        let isFavorite = mockCoreDataManager.isFavorite(id: 1)

        // Then
        XCTAssertTrue(isFavorite)
    }

    func testIsFavorite_ReturnsFalseIfItemIsNotFavorite() {
        // Given
        let item = MenuItem(id: 1, name: "Coffee", category: "Beverage", price: 5.0, imageURL: "coffee_image_url")

        // When
        let isFavorite = mockCoreDataManager.isFavorite(id: 1)

        // Then
        XCTAssertFalse(isFavorite)
    }

    func testToggleFavorite_AddsItemIfNotFavorite() {
        // Given
        let item = MenuItem(id: 1, name: "Coffee", category: "Beverage", price: 5.0, imageURL: "coffee_image_url")

        // When
        mockCoreDataManager.toggleFavorite(item: item)

        // Then
        XCTAssertTrue(mockCoreDataManager.isFavorite(id: 1))
    }

    func testToggleFavorite_RemovesItemIfFavorite() {
        // Given
        let item = MenuItem(id: 1, name: "Coffee", category: "Beverage", price: 5.0, imageURL: "coffee_image_url")
        mockCoreDataManager.saveFavorite(item: item)

        // When
        mockCoreDataManager.toggleFavorite(item: item)

        // Then
        XCTAssertFalse(mockCoreDataManager.isFavorite(id: 1))
    }

    func testFetchFavorites_ReturnsAllFavorites() {
        // Given
        let item1 = MenuItem(id: 1, name: "Coffee", category: "Beverage", price: 5.0, imageURL: "coffee_image_url")
        let item2 = MenuItem(id: 2, name: "Tea", category: "Beverage", price: 3.0, imageURL: "tea_image_url")
        mockCoreDataManager.saveFavorite(item: item1)
        mockCoreDataManager.saveFavorite(item: item2)

        // When
        let favorites = mockCoreDataManager.fetchFavorites()

        // Then
        XCTAssertEqual(favorites.count, 2)
        XCTAssertEqual(favorites[0].name, "Coffee")
        XCTAssertEqual(favorites[1].name, "Tea")
    }
}

