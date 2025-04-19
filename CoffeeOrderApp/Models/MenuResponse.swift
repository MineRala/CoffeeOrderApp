//
//  MenuResponse.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 18.04.2025.
//

import Foundation

struct MenuResponse: Codable {
    let items: [MenuItem]
}

struct MenuItem: Codable, Identifiable {
    let id: Int
    let name: String
    let category: String
    let price: Double
    let imageURL: String
}

extension MenuItem {
    var isFavorite: Bool {
        return CoreDataManager.shared.isFavorite(id: id)
    }
}
