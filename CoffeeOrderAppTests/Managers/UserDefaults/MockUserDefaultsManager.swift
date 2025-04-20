//
//  MockUserDefaultsManager.swift
//  CoffeeOrderAppTests
//
//  Created by Mine Rala on 20.04.2025.
//

import Foundation
@testable import CoffeeOrderApp


final class MockUserDefaultsManager: UserDefaultsProtocol {
    var cartItems: [CartItem] = []

    func saveCartItems(_ items: [CartItem]) {
        cartItems = items
    }

    func loadCartItems() -> [CartItem]? {
        return cartItems
    }

    func removeItem(at index: Int) {
        cartItems.remove(at: index)
    }

    func isEmpty() -> Bool {
        return cartItems.isEmpty
    }

    func clearAllItems() {
        cartItems = []
    }
}
