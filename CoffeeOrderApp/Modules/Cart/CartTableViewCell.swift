//
//  CartTableViewCell.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 20.04.2025.
//

import UIKit
import SnapKit

final class CartTableViewCell: UITableViewCell {
    // MARK: - UI Components

    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10
        view.backgroundColor = .lightGray.withAlphaComponent(0.1)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 5
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()

    private lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "1"
        label.textAlignment = .center
        return label
    }()

    private lazy var increaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
        return button
    }()

    private lazy var decreaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)
        return button
    }()

    private lazy var quantityStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [decreaseButton, quantityLabel, increaseButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        stackView.layer.cornerRadius = 20
        stackView.clipsToBounds = true
        return stackView
    }()

    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemPurple
        return label
    }()

    private var currentItem: CartItem?
    private var userDefaults: UserDefaultsProtocol?

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(containerView)
        [nameLabel, priceLabel, quantityStackView, totalPriceLabel].forEach {
            containerView.addSubview($0)
        }

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.equalTo(nameLabel)
        }

        quantityStackView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(12)
            make.right.equalTo(containerView.snp.right).offset(-12)
            make.height.equalTo(40)
            make.width.equalTo(120)
        }

        totalPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(12)
            make.left.equalTo(priceLabel)
            make.bottom.equalToSuperview().inset(16)
        }
    }

    // MARK: - Configure Cell

    func configure(with item: CartItem, userDefaults: UserDefaultsProtocol? = nil) {
        self.userDefaults = userDefaults
        currentItem = item
        nameLabel.text = item.name
        priceLabel.text = "$\(String(format: "%.2f", item.price))"
        quantityLabel.text = "\(item.quantity)"
        totalPriceLabel.text = "\(AppString.totalWith.localized) $\(String(format: "%.2f", item.price * Double(item.quantity)))"
    }

    // MARK: - Actions

    @objc private func increaseQuantity() {
        guard var item = currentItem else { return }
        item.quantity += 1
        updateItem(item)
    }

    @objc private func decreaseQuantity() {
        guard var item = currentItem else { return }
        if item.quantity > 1 {
            item.quantity -= 1
            updateItem(item)
        } else {
            removeItem(item)
        }
    }

    private func updateItem(_ item: CartItem) {
        if var items = UserDefaultsManager().loadCartItems(),
           let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item

            guard let userDefaults = userDefaults else {
                assertionFailure("UserDefaults dependency is missing!")
                return
            }
            
            userDefaults.saveCartItems(items)
            NotificationCenter.default.post(name: .cartUpdated, object: nil)
        }
        configure(with: item)
    }

    private func removeItem(_ item: CartItem) {
        if var items = UserDefaultsManager().loadCartItems(),
           let index = items.firstIndex(where: { $0.id == item.id }) {
            items.remove(at: index)

            guard let userDefaults = userDefaults else {
                assertionFailure("UserDefaults dependency is missing!")
                return
            }

            userDefaults.saveCartItems(items)
            NotificationCenter.default.post(name: .cartUpdated, object: nil)
        }
    }
}
