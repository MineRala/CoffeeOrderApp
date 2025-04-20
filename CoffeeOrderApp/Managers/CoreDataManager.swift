//
//  CoreDataManager.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 19.04.2025.
//
import CoreData
import UIKit

protocol CoreDataManagerProtocol {
    func saveFavorite(item: MenuItem)
    func removeFavorite(id: Int)
    func isFavorite(id: Int) -> Bool
    func toggleFavorite(item: MenuItem)
    func fetchFavorites() -> [FavoriteItem]
}

final class CoreDataManager: CoreDataManagerProtocol {
    static let shared = CoreDataManager()

    private let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: AppString.favoriteItem)
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Error loading Core Data: \(error)")
            }
        }
    }

    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveFavorite(item: MenuItem) {
        let favorite = FavoriteItem(context: context)
        favorite.id = Int64(item.id)
        favorite.name = item.name
        favorite.category = item.category
        favorite.price = item.price
        favorite.imageURL = item.imageURL

        saveContext()
    }

    func removeFavorite(id: Int) {
        let fetchRequest: NSFetchRequest<FavoriteItem> = FavoriteItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        if let result = try? context.fetch(fetchRequest), let objectToDelete = result.first {
            context.delete(objectToDelete)
            saveContext()
        }
    }

    func isFavorite(id: Int) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteItem> = FavoriteItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        let count = (try? context.count(for: fetchRequest)) ?? 0
        return count > 0
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
        let fetchRequest: NSFetchRequest<FavoriteItem> = FavoriteItem.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error retrieving favorites list: \(error)")
            return []
        }
    }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save Core Data: \(error.localizedDescription)")
            }
        }
    }
}
