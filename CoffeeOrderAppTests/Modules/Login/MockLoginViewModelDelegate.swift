//
//  MockLoginViewModelDelegate.swift
//  CoffeeOrderAppTests
//
//  Created by Mine Rala on 20.04.2025.
//

import Foundation
@testable import CoffeeOrderApp

class MockLoginViewModelDelegate: LoginViewModelDelegate {
    var loginDidSucceedCalled = false
    var loginDidFailCalled = false
    var loginError: AppError?

    func loginDidSucceed() {
        loginDidSucceedCalled = true
    }

    func loginDidFail(with error: AppError) {
        loginDidFailCalled = true
        loginError = error
    }
}
