//
//  UserDefaultsManager.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 20.04.2025.
//

import Foundation

protocol UserDefaultsProtocol {
    func saveCartItems(_ items: [CartItem])
    func loadCartItems() -> [CartItem]?
    func removeItem(at index: Int)
    func isEmpty() -> Bool
    func clearAllItems()
}


final class UserDefaultsManager: UserDefaultsProtocol {
    private let cartKey = "cartItems"

    func saveCartItems(_ items: [CartItem]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(items) {
            UserDefaults.standard.set(encoded, forKey: cartKey)
        }
    }

    func loadCartItems() -> [CartItem]? {
        if let savedData = UserDefaults.standard.data(forKey: cartKey) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([CartItem].self, from: savedData) {
                return decoded
            }
        }
        return nil
    }

    func removeItem(at index: Int) {
        var items = loadCartItems() ?? []
        items.remove(at: index)
        saveCartItems(items)
    }

    func isEmpty() -> Bool {
        return loadCartItems()?.isEmpty ?? true
    }

    func clearAllItems() {
        UserDefaults.standard.removeObject(forKey: cartKey)
        UserDefaults.standard.set([], forKey: cartKey)
    }
}

