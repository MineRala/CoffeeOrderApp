//
//  String+Ext.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 19.04.2025.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
}
