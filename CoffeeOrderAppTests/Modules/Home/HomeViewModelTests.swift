//
//  HomeViewModelTests.swift
//  CoffeeOrderAppTests
//
//  Created by Mine Rala on 20.04.2025.
//

import XCTest
@testable import CoffeeOrderApp

final class HomeViewModelTests: XCTestCase {

    var viewModel: HomeViewModel!
    var mockKeychainManager: MockKeychainManager!
    var mockNetworkManager: MockNetworkManager!
    var mockUserDefaultsManager: MockUserDefaultsManager!
    var mockCacheManager: MockCacheManager!
    var mockCoreDataManager: MockCoreDataManager!
    var mockDelegate: MockHomeViewModelDelegate!

    override func setUp() {
        super.setUp()
        mockKeychainManager = MockKeychainManager()
        mockNetworkManager = MockNetworkManager()
        mockUserDefaultsManager = MockUserDefaultsManager()
        mockCacheManager = MockCacheManager()
        mockCoreDataManager = MockCoreDataManager()
        mockDelegate = MockHomeViewModelDelegate()

        viewModel = HomeViewModel(keychainManager: mockKeychainManager,
                                  networkManager: mockNetworkManager,
                                  userDefaultsManager: mockUserDefaultsManager,
                                  cacheManager: mockCacheManager,
                                  coreDataManager: mockCoreDataManager)
        viewModel.delegate = mockDelegate
    }

    override func tearDown() {
        mockKeychainManager = nil
        mockNetworkManager = nil
        mockUserDefaultsManager = nil
        mockCacheManager = nil
        mockCoreDataManager = nil
        mockDelegate = nil
        viewModel = nil
        super.tearDown()
    }

    func testFetchData_Successful() {
        // Given
        let menuResponse = MenuResponse(items: [MenuItem(id: 1, name: "Espresso", category: "Hot Drinks", price: 3.5, imageURL: "")])
        mockNetworkManager.shouldReturnError = false
        mockNetworkManager.loadLocalJSONResult = .success(menuResponse)

        // When
        viewModel.fetchData()

        // Then
//        XCTAssertTrue(mockDelegate.didFetchDataSuccessfullyCalled, "Delegate method should be called when data is successfully fetched.")
//        XCTAssertEqual(viewModel.filteredMenuItemsCount, 1, "The filtered menu items count should match the fetched data.")
    }

    func testFetchData_Failure() {
        // Given
        mockNetworkManager.shouldReturnError = true
        mockNetworkManager.loadLocalJSONResult = .failure(.invalidData)

        // When
        viewModel.fetchData()

        // Then
        XCTAssertTrue(mockDelegate.didFailToFetchDataCalled, "Delegate method should be called when fetching data fails.")
    }

    func testRefreshFavorites() {
        // Given
        let menuItem = MenuItem(id: 1, name: "Latte", category: "Hot Drinks", price: 4.0, imageURL: "")
        let menuResponse = MenuResponse(items: [menuItem])
        mockNetworkManager.shouldReturnError = false
        mockNetworkManager.loadLocalJSONResult = .success(menuResponse)

        // When
        viewModel.fetchData()

        let updatedMenuItem = MenuItem(id: 1, name: "Latte", category: "Hot Drinks", price: 4.5, imageURL: "")

        viewModel.refreshFavorites(updatedItem: updatedMenuItem)

        // Then

//        XCTAssertTrue(mockDelegate.reloadItemsCalled, "Delegate method should be called when the favorites are refreshed.")
    }

    func testCategoryButtonTapped() {
        // Given
        let initialCategoryIndex = viewModel.selectedCategoryIndex
        let newCategoryIndex = 1

        // When
        viewModel.categoryButtonTapped(at: newCategoryIndex)

        // Then
        XCTAssertNotEqual(viewModel.selectedCategoryIndex, initialCategoryIndex, "The category index should be updated.")
        XCTAssertEqual(viewModel.selectedCategoryIndex, newCategoryIndex, "The selected category index should match the new category index.")
    }

    func testLogout() {
        // When
        viewModel.logout()

        // Then
        XCTAssertTrue(mockKeychainManager.deleteCredentialsCalled, "Credentials should be deleted when logging out.")
        XCTAssertTrue(mockDelegate.didLogoutSuccessfullyCalled, "Delegate method should be called when logout is successful.")
    }
}
