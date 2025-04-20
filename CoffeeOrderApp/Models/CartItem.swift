//
//  CartItem.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 20.04.2025.
//

import Foundation

struct CartItem: Codable {
    let id: Int
    let name: String
    let price: Double
    var quantity: Int
}
