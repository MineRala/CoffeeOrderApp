//
//  DetailViewModel.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 20.04.2025.
//

import Foundation


protocol DetailViewModelProtocol {
    var userDefaultsManager: UserDefaultsProtocol { get }
    var delegate: DetailViewModelDelegate? { get set }

    func increaseQuantity()
    func decreaseQuantitiy()
    func getQuantitityCount() -> Int
    func isQuantityGraterThanOne() -> Bool
    func getTotalPrice() -> Double
    func addToCart()
    func getMenuItem() -> MenuItem
}

protocol DetailViewModelDelegate: AnyObject {
    func popVC()
}

final class DetailViewModel {
    public let userDefaultsManager: UserDefaultsProtocol
    private var menuItem: MenuItem
    private var quantity: Int = 1
    public weak var delegate: DetailViewModelDelegate?

    init(menuItem: MenuItem, userDefaultsManager: UserDefaultsProtocol) {
        self.menuItem = menuItem
        self.userDefaultsManager = userDefaultsManager
    }
}

// MARK: - DetailViewModelProtocol
extension DetailViewModel: DetailViewModelProtocol {
    func increaseQuantity() {
        quantity += 1
    }

    func decreaseQuantitiy() {
        quantity -= 1
    }

    func getQuantitityCount() -> Int {
        quantity
    }

    func isQuantityGraterThanOne() -> Bool {
        quantity > 1
    }

    func getTotalPrice() -> Double {
        return menuItem.price * Double(quantity)
    }

    func addToCart() {
        let cartItem = CartItem(id: menuItem.id, name: menuItem.name, price: menuItem.price, quantity: quantity)
        var cartItems = userDefaultsManager.loadCartItems() ?? []
        if let index = cartItems.firstIndex(where: { $0.id == cartItem.id }) {
            cartItems[index].quantity += cartItem.quantity
        } else {
            cartItems.append(cartItem)
        }

        userDefaultsManager.saveCartItems(cartItems)

        NotificationCenter.default.post(name: .cartUpdated, object: nil)

        NotificationCenter.default.post(name: .cartItemAdded, object: menuItem.name)

        self.delegate?.popVC()
    }

    func getMenuItem() -> MenuItem {
        menuItem
    }
}
