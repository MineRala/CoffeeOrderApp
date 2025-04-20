//
//  UIViewController+Ext.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 18.04.2025.
//

import UIKit
import SnapKit

extension UIViewController {
    func showAlert(title: String, message: String, buttonTitle: String = AppString.ok.localized) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default))
        self.present(alert, animated: true, completion: nil)
    }

    func showSnackBar(message: String, duration: TimeInterval = 1.5) {
        let snackBar = UIView()
        snackBar.backgroundColor = .systemPurple.withAlphaComponent(0.8)
        snackBar.layer.cornerRadius = 12
        snackBar.clipsToBounds = true
        snackBar.alpha = 0

        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        snackBar.addSubview(messageLabel)
        view.addSubview(snackBar)

        snackBar.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(100)
            make.height.equalTo(60)
        }

        messageLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        UIView.animate(withDuration: 0.3, animations: {
            snackBar.alpha = 1
            snackBar.transform = CGAffineTransform(translationX: 0, y: -100)
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseInOut, animations: {
                snackBar.alpha = 0
                snackBar.transform = .identity
            }) { _ in
                snackBar.removeFromSuperview()
            }
        }
    }
}
