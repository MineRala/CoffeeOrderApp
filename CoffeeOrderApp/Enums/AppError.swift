//
//  ErrorMessage.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 18.04.2025.
//

import Foundation

public enum AppError: String, Error {
    case invalidKeyword
    case invalidEmail
    case emptyEmail
    case invalidPassword
    case emptyPassword
    case unableToComplete
    case invalidResponse
    case invalidData
    case invalidURLLink
    case invalidURL
    case checkingError

    var localizedDescription: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
