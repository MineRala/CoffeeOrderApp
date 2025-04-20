//
//  MockNetworkManager.swift
//  CoffeeOrderAppTests
//
//  Created by Mine Rala on 20.04.2025.
//

import Foundation
@testable import CoffeeOrderApp

enum MockError: Error {
    case invalidMockData
}

final class MockNetworkManager: NetworkManagerProtocol {
    var shouldReturnError = false

    func loadLocalJSON<T: Decodable>(filename: String, type: T.Type, completion: @escaping (Result<T, AppError>) -> Void) {
        if shouldReturnError {
            completion(.failure(.invalidData))
        } else {
            let mockData: [String: Any] = ["id": 1, "name": "Coffee", "category": "Hot Drinks", "price": 5.0, "imageURL": "coffee_image_url"]

            // Assuming we are dealing with a model like MenuItem
            if let jsonData = try? JSONSerialization.data(withJSONObject: mockData, options: []) {
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: jsonData)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.invalidData))
                }
            } else {
                completion(.failure(.invalidData))
            }
        }
    }
}

