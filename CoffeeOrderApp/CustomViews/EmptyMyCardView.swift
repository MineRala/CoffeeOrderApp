//
//  EmptyMyCardView.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 19.04.2025.
//

import UIKit

class EmptyView: UIView {

    private lazy var emptyIcon: UIImageView = {
        let imageView = UIImageView(image: Images.squareGrid)
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = AppString.emptyCard.localized
        label.textColor = .systemGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        self.addSubview(emptyIcon)
        self.addSubview(emptyLabel)

        emptyIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(40)
            make.width.height.equalTo(60)
        }

        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyIcon.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }
    }

    func configure(message: String, iconName: String) {
        emptyLabel.text = message
        emptyIcon.image = UIImage(systemName: iconName)
    }
}
