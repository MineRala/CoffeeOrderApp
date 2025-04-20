//
//  DetailViewController.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 19.04.2025.
//

import UIKit
import SnapKit

final class DetailViewController: UIViewController {
    // MARK:  Properties
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(Images.arrowshapeBackward?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.backgroundColor = .purple
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = AppString.one
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var increaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(AppString.increase, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var decreaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(AppString.decrease, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .right
        label.text = AppString.total.localized
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(AppString.addToCart.localized, for: .normal)
        button.backgroundColor = .purple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var priceTotalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [totalLabel, totalPriceLabel])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var quantityStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [decreaseButton, quantityLabel, increaseButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        stackView.layer.cornerRadius = 20
        stackView.clipsToBounds = true
        return stackView
    }()

    private var menuItem: MenuItem?
    private var quantity: Int = 1

    // MARK: - Initializer
    init(menuItem: MenuItem) {
        self.menuItem = menuItem
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
    }
}

// MARK: - UI Setup
extension DetailViewController {
    private func setupUI() {
        navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(priceLabel)
        view.addSubview(backButton)
        view.addSubview(priceTotalStackView)
        view.addSubview(addToCartButton)
        view.addSubview(dividerView)
        view.addSubview(quantityStackView)

        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.4)
        }

        backButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.top).offset(10)
            make.left.equalTo(imageView.snp.left).offset(10)
            make.width.height.equalTo(50)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }

        quantityStackView.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(40)
            make.width.equalTo(view.snp.width).multipliedBy(0.3)
        }

        addToCartButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }

        totalPriceLabel.snp.makeConstraints { make in
            make.bottom.equalTo(addToCartButton.snp.top).offset(-30)
            make.right.equalTo(addToCartButton.snp.right).inset(8)
            make.width.equalTo(84)
        }

        dividerView.snp.makeConstraints { make in
            make.bottom.equalTo(totalLabel.snp.top).offset(-8)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(0.5)
        }
    }

    // MARK: - Config Method
    private func configure() {
        guard let item = menuItem else { return }
        nameLabel.text = item.name
        priceLabel.text = "$\(item.price)"
        updateTotalPrice()

        CacheManager.shared.loadImage(from: item.imageURL) { [weak self] image in
            guard let self = self else { return }
            if let image = image {
                self.imageView.image = image
            }
        }
    }
}

// MARK: - Actions
extension DetailViewController {
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func increaseQuantity() {
        quantity += 1
        quantityLabel.text = "\(quantity)"
        updateTotalPrice()
    }

    @objc private func decreaseQuantity() {
        if quantity > 1 {
            quantity -= 1
            quantityLabel.text = "\(quantity)"
            updateTotalPrice()
        }
    }

    @objc private func addToCart() {
        guard let item = menuItem else { return }

        let cartItem = CartItem(id: item.id, name: item.name, price: item.price, quantity: quantity)
        var cartItems = UserDefaultsManager().loadCartItems() ?? []

        if let index = cartItems.firstIndex(where: { $0.id == cartItem.id }) {
            cartItems[index].quantity += cartItem.quantity
        } else {
            cartItems.append(cartItem)
        }

        UserDefaultsManager().saveCartItems(cartItems)

        NotificationCenter.default.post(name: .cartUpdated, object: nil)

        NotificationCenter.default.post(name: .cartItemAdded, object: item.name)

        navigationController?.popViewController(animated: true)
    }

    private func updateTotalPrice() {
        guard let item = menuItem else { return }
        let total = item.price * Double(quantity)
        totalPriceLabel.text = "$\(String(format: "%.2f", total))"
    }
}
