//
//  LoginViewModelTests.swift
//  CoffeeOrderAppTests
//
//  Created by Mine Rala on 20.04.2025.
//

import XCTest
@testable import CoffeeOrderApp

final class LoginViewModelTests: XCTestCase {
    var viewModel: LoginViewModel!
    var mockKeychainManager: MockKeychainManager!
    var mockNetworkManager: MockNetworkManager!
    var mockUserDefaultsManager: MockUserDefaultsManager!
    var mockCacheManager: MockCacheManager!
    var mockDelegate: MockLoginViewModelDelegate!

    override func setUp() {
        super.setUp()
        mockKeychainManager = MockKeychainManager()
        mockNetworkManager = MockNetworkManager()
        mockUserDefaultsManager = MockUserDefaultsManager()
        mockCacheManager = MockCacheManager()
        mockDelegate = MockLoginViewModelDelegate()

        viewModel = LoginViewModel(keychainManager: mockKeychainManager,
                                   networkManager: mockNetworkManager,
                                   userDefaultsManager: mockUserDefaultsManager,
                                   cacheManager: mockCacheManager)
        viewModel.delegate = mockDelegate
    }

    override func tearDown() {
        mockKeychainManager = nil
        mockNetworkManager = nil
        mockUserDefaultsManager = nil
        mockCacheManager = nil
        mockDelegate = nil
        viewModel = nil
        super.tearDown()
    }

    // Test: Boş e-posta ile giriş
    func testLogin_EmptyEmail() {
        // Given
        let email = ""
        let password = "Password123"

        // When: login fonksiyonu çağrılır
        viewModel.login(email: email, password: password)

        // Then: loginDidFail çağrılmalıdır
        XCTAssertTrue(mockDelegate.loginDidFailCalled)
        XCTAssertEqual(mockDelegate.loginError, .emptyEmail)

        // Keychain'e kaydedilmemiş olmalı
        XCTAssertFalse(mockKeychainManager.saveCredentialsCalled)
        XCTAssertNil(mockKeychainManager.storedEmail)
        XCTAssertNil(mockKeychainManager.storedPassword)
    }

    // Test: Boş şifre ile giriş
    func testLogin_EmptyPassword() {
        // Given
        let email = "test@example.com"
        let password = ""

        // When: login fonksiyonu çağrılır
        viewModel.login(email: email, password: password)

        // Then: loginDidFail çağrılmalıdır
        XCTAssertTrue(mockDelegate.loginDidFailCalled)
        XCTAssertEqual(mockDelegate.loginError, .emptyPassword)

        // Keychain'e kaydedilmemiş olmalı
        XCTAssertFalse(mockKeychainManager.saveCredentialsCalled)
        XCTAssertNil(mockKeychainManager.storedEmail)
        XCTAssertNil(mockKeychainManager.storedPassword)
    }

    // Test: Geçersiz email formatı ile giriş
    func testLogin_InvalidEmail() {
        // Given
        let email = "invalid-email"
        let password = "Password123"

        // When: login fonksiyonu çağrılır
        viewModel.login(email: email, password: password)

        // Then: loginDidFail çağrılmalıdır
        XCTAssertTrue(mockDelegate.loginDidFailCalled)
        XCTAssertEqual(mockDelegate.loginError, .invalidEmail)

        // Keychain'e kaydedilmemiş olmalı
        XCTAssertFalse(mockKeychainManager.saveCredentialsCalled)
        XCTAssertNil(mockKeychainManager.storedEmail)
        XCTAssertNil(mockKeychainManager.storedPassword)
    }

    // Test: Geçersiz şifre ile giriş
    func testLogin_InvalidPassword() {
        // Given
        let email = "test@example.com"
        let password = "123"

        // When: login fonksiyonu çağrılır
        viewModel.login(email: email, password: password)

        // Then: loginDidFail çağrılmalıdır
        XCTAssertTrue(mockDelegate.loginDidFailCalled)
        XCTAssertEqual(mockDelegate.loginError, .invalidPassword)

        // Keychain'e kaydedilmemiş olmalı
        XCTAssertFalse(mockKeychainManager.saveCredentialsCalled)
        XCTAssertNil(mockKeychainManager.storedEmail)
        XCTAssertNil(mockKeychainManager.storedPassword)
    }

    // Test: Başarılı giriş
    func testLogin_Successful() {
        // Given
        let email = "test@example.com"
        let password = "Password123"

        // When: login fonksiyonu çağrılır
        viewModel.login(email: email, password: password)

        // Then: loginDidSucceed çağrılmalıdır
        XCTAssertTrue(mockDelegate.loginDidSucceedCalled)

        // Keychain'e kaydedilmelidir
        XCTAssertTrue(mockKeychainManager.saveCredentialsCalled)
        XCTAssertEqual(mockKeychainManager.storedEmail, email)
        XCTAssertEqual(mockKeychainManager.storedPassword, password)
    }
}
