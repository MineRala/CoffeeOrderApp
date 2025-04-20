//
//  CartViewModel.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 20.04.2025.
//

import Foundation

protocol CartViewModelProtcol {
    var userDefaultsManager: UserDefaultsProtocol { get }
    var delegate: CartViewModelDelegate? { get set }

    var cartItemsCount: Int { get }

    func loadCardItems()
    func isEmptyCardItems() -> Bool
    func orderButtonTapped()
    func deleteItem(at index: Int)
    func getCartItem(index: Int) -> CartItem
}

protocol CartViewModelDelegate: AnyObject {
    func updateVisibiltyState()
    func reloadData()
    func setTotalPriceLabel(with text: String)
}

final class CartViewModel {
    public let userDefaultsManager: UserDefaultsProtocol
    public weak var delegate: CartViewModelDelegate?

    private var cartItems: [CartItem] = []

    init(userDefaultsManager: UserDefaultsProtocol) {
        self.userDefaultsManager = userDefaultsManager
    }
}

// MARK: - Private
extension CartViewModel {
    private func updateTotalPrice() {
        let totalPrice = cartItems.reduce(0) { total, item in
            let itemTotal = item.price * Double(item.quantity)
            return total + itemTotal
        }
        delegate?.setTotalPriceLabel(with: "\(AppString.totalWith.localized)\(String(format: "%.2f", totalPrice))")
    }
}

// MARK: - CartViewModelProtcol
extension CartViewModel: CartViewModelProtcol {
    var cartItemsCount: Int {
        cartItems.count
    }
    
    func isEmptyCardItems() -> Bool {
        cartItems.isEmpty
    }
    
    func loadCardItems() {
        if let items = userDefaultsManager.loadCartItems() {
            cartItems = items
            delegate?.updateVisibiltyState()
            delegate?.reloadData()
            updateTotalPrice()
        }
    }

    func orderButtonTapped() {
        userDefaultsManager.clearAllItems()

        cartItems.removeAll()
        delegate?.reloadData()
        delegate?.updateVisibiltyState()
        updateTotalPrice()
    }

    func deleteItem(at index: Int) {
        cartItems.remove(at: index)

        userDefaultsManager.saveCartItems(cartItems)

        NotificationCenter.default.post(name: .cartUpdated, object: nil)

        updateTotalPrice()
    }

    func getCartItem(index: Int) -> CartItem {
        cartItems[index]
    }
}
