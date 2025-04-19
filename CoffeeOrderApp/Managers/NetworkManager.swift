//
//  NetworkManager.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 18.04.2025.
//

import Foundation

protocol NetworkManagerProtocol {
    func loadLocalJSON<T: Decodable>(filename: String, type: T.Type, completion: @escaping (Result<T, AppError>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    public init() {}

    func loadLocalJSON<T: Decodable>(filename: String, type: T.Type, completion: @escaping (Result<T, AppError>) -> Void) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            completion(.failure(.invalidURL))
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedData))
        } catch {
            completion(.failure(.invalidData))
        }
    }
}
