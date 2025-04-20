//
//  EmptyFavoriteView.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 19.04.2025.
//

import UIKit
import SnapKit

final class EmptyFavoriteView: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.heartSlash
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = AppString.emptyFavoriteList.localized
        label.textAlignment = .center
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        addSubview(imageView)
        addSubview(messageLabel)

        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
            make.width.height.equalTo(60)
        }

        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
        }
    }
}
