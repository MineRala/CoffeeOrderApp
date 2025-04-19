//
//  TabItem.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 18.04.2025.
//

import UIKit

enum TabItem {
    case home
    case favorites
    case cart

    var title: String {
        switch self {
        case .home: return AppString.home.localized
        case .favorites: return AppString.favorites.localized
        case .cart: return AppString.cart.localized
        }
    }

    var icon: UIImage? {
        switch self {
        case .home: return Images.homeFill
        case .favorites: return Images.heartFill
        case .cart: return Images.cardFill
        }
    }

    var tag: Int {
        switch self {
        case .home: return 0
        case .favorites: return 1
        case .cart: return 2
        }
    }
}
