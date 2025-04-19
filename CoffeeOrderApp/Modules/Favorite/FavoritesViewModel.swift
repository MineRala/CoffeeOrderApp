//
//  FavoritesViewModel.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 19.04.2025.
//

import Foundation

protocol FavoritesViewModelProtocol {
    var filteredFavoritesCount: Int { get }
    var heightForRowAt: CGFloat { get }

    func fetchFavorites(text: String)
    func filterFavorites(with searchText: String)
    func refreshFavorites(with updatedItem: MenuItem)
    func searchBar(with searchText: String)
    func getFavorite(index: Int) -> MenuItem

    var onFavoritesRemoved: ((Int) -> Void)? { get set }
    var onReloadData: (() -> Void)? { get set }
}

final class FavoritesViewModel {
    private var filteredFavorites: [MenuItem] = []
    private var allFavorites: [MenuItem] = []

    var onFavoritesRemoved: ((Int) -> Void)?
    var onReloadData: (() -> Void)?
}

// MARK: - FavoritesViewModel
extension FavoritesViewModel {
    private func convertMenuItem() -> [MenuItem] {
        return CoreDataManager.shared.fetchFavorites().map { item in
            MenuItem(id: Int(item.id), name: item.name ?? "", category: item.category ?? "", price: item.price, imageURL: item.imageURL ?? "")
        }
    }
}

// MARK: - FavoritesViewModelProtocol
extension FavoritesViewModel: FavoritesViewModelProtocol {

    var filteredFavoritesCount: Int {
        filteredFavorites.count

    }

    var heightForRowAt: CGFloat {
        150
    }

    func fetchFavorites(text: String) {
        let fetchedFavorites = convertMenuItem()
        allFavorites = fetchedFavorites
        DispatchQueue.main.async {
            if text.isEmpty {
                self.filteredFavorites = self.allFavorites
            } else {
                self.filterFavorites(with: text)
            }
            self.onReloadData?()
        }
    }

    func filterFavorites(with searchText: String) {
        let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedText.isEmpty {
            filteredFavorites = allFavorites
        } else {
            filteredFavorites = allFavorites.filter {
                $0.name.lowercased().contains(trimmedText.lowercased())
            }
        }
        onReloadData?()
    }

    func refreshFavorites(with updatedItem: MenuItem) {
        let currentFavorites = convertMenuItem()
        if !currentFavorites.contains(where: { $0.id == updatedItem.id }) {
            if let index = filteredFavorites.firstIndex(where: { $0.id == updatedItem.id }) {
                filteredFavorites.remove(at: index)
                onFavoritesRemoved?(index)

                if let allIndex = allFavorites.firstIndex(where: { $0.id == updatedItem.id }) {
                    allFavorites.remove(at: allIndex)
                }        }
        }
    }

    func searchBar(with searchText: String) {
        filterFavorites(with: searchText)
    }

    func getFavorite(index: Int) -> MenuItem {
        filteredFavorites[index]
    }
}
