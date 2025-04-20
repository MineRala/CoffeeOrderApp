//
//  MockCoreDataManager.swift
//  CoffeeOrderAppTests
//
//  Created by Mine Rala on 20.04.2025.
//

import Foundation
@testable import CoffeeOrderApp

final class MockCoreDataManager: CoreDataManagerProtocol {
    var favorites: [FavoriteItem] = []

    func saveFavorite(item: MenuItem) {
        let favorite = FavoriteItem(context: MockManagedObjectContext())
        favorite.id = Int64(item.id)
        favorite.name = item.name
        favorite.category = item.category
        favorite.price = item.price
        favorite.imageURL = item.imageURL
        favorites.append(favorite)
    }

    func removeFavorite(id: Int) {
        favorites.removeAll { $0.id == Int64(id) }
    }

    func isFavorite(id: Int) -> Bool {
        return favorites.contains { $0.id == Int64(id) }
    }

    func toggleFavorite(item: MenuItem) {
        let isCurrentlyFavorite = isFavorite(id: item.id)
        if isCurrentlyFavorite {
            removeFavorite(id: item.id)
        } else {
            saveFavorite(item: item)
        }
    }

    func fetchFavorites() -> [FavoriteItem] {
        return favorites
    }
}
