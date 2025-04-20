//
//  NSNotification+Ext.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 19.04.2025.
//

import Foundation

extension Notification.Name {
    static let favoriteItemUpdated = Notification.Name(AppString.favoriteItemUpdated)
    static let cartUpdated = Notification.Name(AppString.cartUpdated)
    static let cartItemAdded = Notification.Name(AppString.cartItemAdded)

}
