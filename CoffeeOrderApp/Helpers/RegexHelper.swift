//
//  RegexHelper.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 18.04.2025.
//

import Foundation

struct RegexHelper {

    // MARK: - Email Validation
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }

    // MARK: - Password Validation
    static func isValidPassword(_ password: String) -> Bool {
        // At least 8 characters, one uppercase, one lowercase, and one number
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d@$!%*?&]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
}
