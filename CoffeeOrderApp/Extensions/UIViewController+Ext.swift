//
//  UIViewController+Ext.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 18.04.2025.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, buttonTitle: String = AppString.ok.localized) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
