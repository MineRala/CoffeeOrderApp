//
//  KeychainManagerTests.swift
//  CoffeeOrderAppTests
//
//  Created by Mine Rala on 20.04.2025.
//

import XCTest

final class KeychainManagerTests: XCTestCase {

    var mockKeychainManager: MockKeychainManager!

    override func setUp() {
        super.setUp()
        mockKeychainManager = MockKeychainManager()
    }

    override func tearDown() {
        mockKeychainManager = nil
        super.tearDown()
    }

    func testIsUserLoggedIn_WhenCredentialsAreSaved_ReturnsTrue() {
        // Given
        let email = "test@example.com"
        let password = "password123"
        mockKeychainManager.saveCredentials(email: email, password: password)

        // When
        let isLoggedIn = mockKeychainManager.isUserLoggedIn()

        // Then
        XCTAssertTrue(isLoggedIn)
        XCTAssertTrue(mockKeychainManager.isUserLoggedInCalled)
    }

    func testIsUserLoggedIn_WhenNoCredentialsSaved_ReturnsFalse() {
        // Given

        // When
        let isLoggedIn = mockKeychainManager.isUserLoggedIn()

        // Then
        XCTAssertFalse(isLoggedIn)
        XCTAssertTrue(mockKeychainManager.isUserLoggedInCalled)
    }

    func testSaveCredentials_SavesEmailAndPassword() {
        // Given: Email ve şifreyi kaydetmek
        let email = "test@example.com"
        let password = "password123"

        // When
        mockKeychainManager.saveCredentials(email: email, password: password)

        // Then
        XCTAssertEqual(mockKeychainManager.storedEmail, email)
        XCTAssertEqual(mockKeychainManager.storedPassword, password)
        XCTAssertTrue(mockKeychainManager.saveCredentialsCalled)
    }

    func testDeleteCredentials_RemovesEmailAndPassword() {
        // Given
        let email = "test@example.com"
        let password = "password123"
        mockKeychainManager.saveCredentials(email: email, password: password)

        // When
        mockKeychainManager.deleteCredentials()

        // Then
        XCTAssertNil(mockKeychainManager.storedEmail)
        XCTAssertNil(mockKeychainManager.storedPassword)
        XCTAssertTrue(mockKeychainManager.deleteCredentialsCalled)
    }
}
