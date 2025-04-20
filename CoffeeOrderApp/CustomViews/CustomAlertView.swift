//
//  CustomAlertView.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 20.04.2025.
//

import UIKit

final class CustomAlertView: UIView {

    private lazy var alertBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()

    private lazy var alertContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = AppString.areYouSureDelete.localized
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var yesButton: UIButton = {
        let button = UIButton()
        button.setTitle(AppString.yes.localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var noButton: UIButton = {
        let button = UIButton()
        button.setTitle(AppString.no.localized, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(noButtonTapped), for: .touchUpInside)
        return button
    }()

    var onYesTapped: (() -> Void)?
    var onNoTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(alertBackgroundView)
        alertBackgroundView.frame = bounds
        alertBackgroundView.addSubview(alertContainer)

        alertContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(150)
        }

        alertContainer.addSubview(messageLabel)
        alertContainer.addSubview(yesButton)
        alertContainer.addSubview(noButton)

        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(alertContainer).offset(20)
            make.left.right.equalTo(alertContainer).inset(20)
        }

        yesButton.snp.makeConstraints { make in
            make.bottom.equalTo(alertContainer).offset(-20)
            make.right.equalTo(alertContainer).offset(-20)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }

        noButton.snp.makeConstraints { make in
            make.bottom.equalTo(alertContainer).offset(-20)
            make.left.equalTo(alertContainer).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
    }

    @objc private func yesButtonTapped() {
        onYesTapped?()
        removeFromSuperview()
    }

    @objc private func noButtonTapped() {
        onNoTapped?()
        removeFromSuperview()
    }
}
