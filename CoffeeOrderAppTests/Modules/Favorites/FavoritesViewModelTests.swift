//
//  FavoritesViewModelTests.swift
//  CoffeeOrderAppTests
//
//  Created by Mine Rala on 20.04.2025.
//

import XCTest
@testable import CoffeeOrderApp

final class FavoritesViewModelTests: XCTestCase {

    var viewModel: FavoritesViewModel!
    var mockUserDefaultsManager: MockUserDefaultsManager!
    var mockCacheManager: MockCacheManager!
    var mockCoreDataManager: MockCoreDataManager!

    override func setUp() {
        super.setUp()
        mockUserDefaultsManager = MockUserDefaultsManager()
        mockCacheManager = MockCacheManager()
        mockCoreDataManager = MockCoreDataManager()

        viewModel = FavoritesViewModel(
            userDefaultsManager: mockUserDefaultsManager,
            cacheManager: mockCacheManager,
            coreDataManager: mockCoreDataManager
        )
    }

    override func tearDown() {
        viewModel = nil
        mockUserDefaultsManager = nil
        mockCacheManager = nil
        mockCoreDataManager = nil
        super.tearDown()
    }

    func testFetchFavoritesWithoutSearchText_ShouldLoadAll() {
        // Given
        mockCoreDataManager.favorites = [
            createFavoriteItem(id: 1, name: "Latte"),
            createFavoriteItem(id: 2, name: "Mocha")
        ]

        let expectation = expectation(description: "Reload data called")
        viewModel.onReloadData = {
            expectation.fulfill()
        }

        // When
        viewModel.fetchFavorites(text: "")

        // Then
        waitForExpectations(timeout: 1)
        XCTAssertEqual(viewModel.filteredFavoritesCount, 2)
        XCTAssertEqual(viewModel.allFavoritesCount, 2)

        if viewModel.filteredFavoritesCount > 0 {
            let item = viewModel.getFavorite(index: 0)
            XCTAssertNotNil(item)
        } else {
            XCTFail("No items in filteredFavorites")
        }
    }

    func testFilterFavoritesWithSearchText_ShouldFilterCorrectly() {
        // Given
        mockCoreDataManager.favorites = [
            createFavoriteItem(id: 1, name: "Latte"),
            createFavoriteItem(id: 2, name: "Cold Brew")
        ]

        // Step 1: fetchFavorites çağrısı için expectation oluştur
        let initialExpectation = expectation(description: "Initial fetch")
        viewModel.onReloadData = {
            initialExpectation.fulfill()
        }

        viewModel.fetchFavorites(text: "")
        wait(for: [initialExpectation], timeout: 1)

        // Step 2: Arama için yeni expectation oluştur
        let searchExpectation = expectation(description: "Search filter")
        viewModel.onReloadData = {
            searchExpectation.fulfill()
        }

        // When
        viewModel.searchBar(with: "cold")

        // Then
        wait(for: [searchExpectation], timeout: 1)

        XCTAssertEqual(viewModel.filteredFavoritesCount, 1)

        if viewModel.filteredFavoritesCount > 0 {
            let favorite = viewModel.getFavorite(index: 0)
            XCTAssertEqual(favorite.name, "Cold Brew")
        } else {
            XCTFail("No filtered items found")
        }
    }

    func testRefreshFavorites_RemovesUnfavoritedItem() {
        // Given
        let latte = createFavoriteItem(id: 1, name: "Latte")
        mockCoreDataManager.favorites = [latte]

        let fetchExpectation = expectation(description: "Favorites fetched")
        viewModel.onReloadData = {
            fetchExpectation.fulfill()
        }

        // When
        viewModel.fetchFavorites(text: "")
        wait(for: [fetchExpectation], timeout: 1)

        let updatedItem = MenuItem(id: 1, name: "Latte", category: "Hot Drinks", price: 4.0, imageURL: "")

        mockCoreDataManager.favorites = []
        let removalExpectation = expectation(description: "Item removed from favorites")

        viewModel.onFavoritesRemoved = { index in
            XCTAssertEqual(index, 0)
            removalExpectation.fulfill()
        }

        // When
        viewModel.refreshFavorites(with: updatedItem)

        // Then
        wait(for: [removalExpectation], timeout: 1)
        XCTAssertEqual(viewModel.filteredFavoritesCount, 0) // Favorilerde artık hiç öğe olmamalı
    }


    func testGetFavorite_ShouldReturnCorrectItem() {
        // Given
        mockCoreDataManager.favorites = [
            createFavoriteItem(id: 5, name: "Flat White")
        ]

        let reloadExpectation = expectation(description: "Reload data called")
        viewModel.onReloadData = {
            reloadExpectation.fulfill()
        }

        viewModel.fetchFavorites(text: "")
        waitForExpectations(timeout: 1)

        // When
        if viewModel.filteredFavoritesCount > 0 {
            let item = viewModel.getFavorite(index: 0)

            // Then
            XCTAssertEqual(item.id, 5)
            XCTAssertEqual(item.name, "Flat White")
        } else {
            XCTFail("filteredFavorites is empty")
        }
    }

    func testHeightForRowAt_ShouldReturn150() {
        XCTAssertEqual(viewModel.heightForRowAt, 150)
    }

    // MARK: - Helper
    private func createFavoriteItem(id: Int, name: String) -> FavoriteItem {
        let item = FavoriteItem(context: MockManagedObjectContext())
        item.id = Int64(id)
        item.name = name
        item.category = "Hot"
        item.price = 4.0
        item.imageURL = ""
        return item
    }
}
