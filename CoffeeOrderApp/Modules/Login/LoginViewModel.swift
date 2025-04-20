//
//  LoginViewModel.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 18.04.2025.
//

import Foundation

protocol LoginViewModelProtocol {
    var keychainManager: KeychainManagerProtocol { get }
    var networkManager: NetworkManagerProtocol { get }
    var userDefaultsManager: UserDefaultsProtocol { get }
    var cacheManager: CacheManagerProtocol { get }
    var delegate: LoginViewModelDelegate? { get set }

    func login(email: String, password: String)
}

protocol LoginViewModelDelegate: AnyObject {
    func loginDidSucceed()
    func loginDidFail(with error: AppError)
}

final class LoginViewModel {
    public let keychainManager: KeychainManagerProtocol
    public let networkManager: NetworkManagerProtocol
    public let userDefaultsManager: UserDefaultsProtocol
    public let cacheManager: CacheManagerProtocol
    public weak var delegate: LoginViewModelDelegate?

    init(keychainManager: KeychainManagerProtocol, networkManager: NetworkManagerProtocol, userDefaultsManager: UserDefaultsProtocol, cacheManager: CacheManagerProtocol) {
        self.keychainManager = keychainManager
        self.networkManager = networkManager
        self.userDefaultsManager = userDefaultsManager
        self.cacheManager = cacheManager
    }
}

// MARK: - Private
extension LoginViewModel {
    private func performLogin(email: String, password: String) -> AppError? {
        guard !email.isEmpty else {
            return .emptyEmail
        }

        guard !password.isEmpty else {
            return .emptyPassword
        }

        guard isValidEmail(email) else {
            return .invalidEmail
        }

        guard isValidPassword(password) else {
            return .invalidPassword
        }

        keychainManager.saveCredentials(email: email, password: password)
        return nil
    }

    private func isValidEmail(_ email: String) -> Bool {
        return RegexHelper.isValidEmail(email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        return RegexHelper.isValidPassword(password)
    }
}

// MARK: - LoginViewModelProtocol
extension LoginViewModel: LoginViewModelProtocol {
    func login(email: String, password: String) {
        if let error = performLogin(email: email, password: password) {
            delegate?.loginDidFail(with: error)
        } else {
            delegate?.loginDidSucceed()
        }
    }
}
