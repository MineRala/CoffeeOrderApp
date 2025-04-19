//
//  KeychainHelper.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 18.04.2025.
//

import Foundation
import Security

protocol KeychainManagerProtocol {
    func isUserLoggedIn() -> Bool
    func saveCredentials(email: String, password: String)
    func deleteCredentials()
}

final class KeychainManager {
    private func save(_ data: Data, service: String, account: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecValueData: data
        ] as CFDictionary

        SecItemDelete(query)
        SecItemAdd(query, nil)
    }

    private func read(service: String, account: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)

        if status == errSecSuccess {
            return dataTypeRef as? Data
        } else {
            return nil
        }
    }

    private func delete(service: String, account: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary

        SecItemDelete(query)
    }


}

// MARK: - KeychainManagerProtocol
extension KeychainManager: KeychainManagerProtocol {
    func isUserLoggedIn() -> Bool {
        let email = read(service: AppString.email, account: AppString.coffeeApp)
        let password = read(service: AppString.password, account:AppString.coffeeApp)
        return email != nil && password != nil
    }

    func saveCredentials(email: String, password: String) {
        save(Data(email.utf8), service: AppString.email, account: AppString.coffeeApp)
        save(Data(password.utf8), service: AppString.password, account: AppString.coffeeApp)
    }

    func deleteCredentials() {
           delete(service: AppString.email, account: AppString.coffeeApp)
           delete(service: AppString.password, account: AppString.coffeeApp)
       }
}
