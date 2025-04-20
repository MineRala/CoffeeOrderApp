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
    var loadLocalJSONResult: Result<Any, AppError> = .failure(.invalidData)

    func loadLocalJSON<T: Decodable>(filename: String, type: T.Type, completion: @escaping (Result<T, AppError>) -> Void) {
        switch loadLocalJSONResult {
        case .success(let data):
            // Güvenli bir şekilde data'yı Data tipine dönüştürme
            guard let jsonData = data as? Data else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: jsonData)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.invalidData))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
