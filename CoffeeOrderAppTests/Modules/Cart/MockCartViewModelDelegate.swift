//
//  MockCartViewModelDelegate.swift
//  CoffeeOrderAppTests
//
//  Created by Mine Rala on 20.04.2025.
//

import Foundation
@testable import CoffeeOrderApp

final class MockCartViewModelDelegate: CartViewModelDelegate {
    var updateVisibiltyStateCalled = false
    var reloadDataCalled = false
    var setTotalPriceLabelCalled = false

    func updateVisibiltyState() {
        updateVisibiltyStateCalled = true
    }

    func reloadData() {
        reloadDataCalled = true
    }

    func setTotalPriceLabel(with text: String) {
        setTotalPriceLabelCalled = true
    }
}
