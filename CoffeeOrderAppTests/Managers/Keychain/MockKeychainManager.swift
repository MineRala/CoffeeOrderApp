//
//  MockKeychainManager.swift
//  CoffeeOrderAppTests
//
//  Created by Mine Rala on 20.04.2025.
//

import Foundation
@testable import CoffeeOrderApp


final class MockKeychainManager: KeychainManagerProtocol {
    var isUserLoggedInCalled = false
    var saveCredentialsCalled = false
    var deleteCredentialsCalled = false
    var storedEmail: String?
    var storedPassword: String?

    func isUserLoggedIn() -> Bool {
        isUserLoggedInCalled = true
        return storedEmail != nil && storedPassword != nil
    }

    func saveCredentials(email: String, password: String) {
        saveCredentialsCalled = true
        storedEmail = email
        storedPassword = password
    }

    func deleteCredentials() {
        deleteCredentialsCalled = true
        storedEmail = nil
        storedPassword = nil
    }
}

