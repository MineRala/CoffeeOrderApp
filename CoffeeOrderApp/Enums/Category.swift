//
//  Category.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 18.04.2025.
//

import Foundation

public enum Category: String, CaseIterable {
    case all
    case hotDrink
    case coldDrink
    case food

    var title: String {
        switch self {
        case .all: return AppString.all.localized
        case .hotDrink: return AppString.hotDrinks.localized
        case .coldDrink: return AppString.coldDrinks.localized
        case .food: return AppString.food.localized
        }
    }

    func items(from allItems: [MenuItem]) -> [MenuItem] {
        switch self {
        case .all:
            return allItems
        case .hotDrink:
            return allItems.filter { $0.category == "hotDrinks" }
        case .coldDrink:
            return allItems.filter { $0.category == "coldDrinks" }
        case .food:
            return allItems.filter { $0.category == "food" }
        }
    }
}
