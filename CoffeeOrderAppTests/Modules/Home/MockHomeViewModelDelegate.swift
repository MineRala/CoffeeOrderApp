//
//  MockHomeViewModelDelegate.swift
//  CoffeeOrderAppTests
//
//  Created by Mine Rala on 20.04.2025.
//

import Foundation
@testable import CoffeeOrderApp

final class MockHomeViewModelDelegate: HomeViewModelDelegate {
    var didFetchDataSuccessfullyCalled = false
    var didFailToFetchDataCalled = false
    var reloadItemsCalled = false
    var didLogoutSuccessfullyCalled = false

    func reloadItems(at indexPath: IndexPath) {
        reloadItemsCalled = true
    }

    func didLogoutSuccessfully() {
        didLogoutSuccessfullyCalled = true
    }

    func didFetchDataSuccessfully() {
        didFetchDataSuccessfullyCalled = true
    }

    func didFailToFetchData(with error: AppError) {
        didFailToFetchDataCalled = true
    }
}
