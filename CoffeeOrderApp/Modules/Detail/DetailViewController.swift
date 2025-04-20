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

    private var viewModel: DetailViewModelProtocol

    // MARK: - Initializer
    init(viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
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

// MARK: - UI
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

    private func configure() {
        nameLabel.text = viewModel.getMenuItem().name
        priceLabel.text = "$\(viewModel.getMenuItem().price)"
        updateTotalPrice()

        CacheManager.shared.loadImage(from: viewModel.getMenuItem().imageURL) { [weak self] image in
            guard let self else { return }
            if let image = image {
                self.imageView.image = image
            }
        }
    }
}

// MARK: - Helpers
extension DetailViewController {
    private func updateTotalPrice() {
        let total = viewModel.getTotalPrice()
        totalPriceLabel.text = "$\(String(format: "%.2f", total))"
    }
}

// MARK: - Actions
extension DetailViewController {
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func increaseQuantity() {
        viewModel.increaseQuantity()
        quantityLabel.text = "\(viewModel.getQuantitityCount())"
        updateTotalPrice()
    }

    @objc private func decreaseQuantity() {
        if viewModel.isQuantityGraterThanOne() {
            viewModel.decreaseQuantitiy()
            quantityLabel.text = "\(viewModel.getQuantitityCount())"
            updateTotalPrice()

        }
    }

    @objc private func addToCart() {
        viewModel.addToCart()
    }
}


// MARK:
extension DetailViewController: DetailViewModelDelegate {
    func popVC() {
        navigationController?.popViewController(animated: true)
    }

}
