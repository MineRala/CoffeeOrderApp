//
//  TableCardViewCell.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 19.04.2025.
//

import UIKit
import SnapKit

final class TableCardViewCell: UITableViewCell {
    // MARK: - UI Elements
    private lazy var cardView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10
        view.backgroundColor = .lightGray.withAlphaComponent(0.1)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var itemNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var itemPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        button.backgroundColor = .lightGray
        button.setImage(Images.heartFill, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var menuItem: MenuItem?
    private var coreDataManager: CoreDataManagerProtocol?


    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        itemNameLabel.text = nil
        itemPriceLabel.text = nil
        itemImageView.image = nil
        favoriteButton.backgroundColor = .lightGray
    }
}

// MARK: - UI
extension TableCardViewCell {
    private func setupUI() {
        self.selectedBackgroundView = UIView()
        self.selectionStyle = .none

        contentView.addSubview(cardView)
        cardView.addSubview(itemImageView)
        cardView.addSubview(itemNameLabel)
        cardView.addSubview(itemPriceLabel)
        cardView.addSubview(favoriteButton)

        cardView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(10)
        }

        itemImageView.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.top).offset(10)
            make.left.equalTo(cardView.snp.left).offset(10)
            make.bottom.equalTo(cardView.snp.bottom).offset(-10)
            make.width.equalToSuperview().multipliedBy(0.3)
        }

        itemNameLabel.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.top).offset(20)
            make.left.equalTo(itemImageView.snp.right).offset(10)
            make.right.equalTo(cardView.snp.right).offset(-10)
        }

        itemPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(itemNameLabel.snp.bottom).offset(5)
            make.left.equalTo(itemImageView.snp.right).offset(10)
            make.right.equalTo(cardView.snp.right).offset(-10)
        }

        favoriteButton.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.top).offset(10)
            make.right.equalTo(cardView.snp.right).offset(-10)
            make.width.height.equalTo(36)
        }
    }
}

// MARK: - Configure Cell
extension TableCardViewCell {
    func configure(with item: MenuItem, cacheManager: CacheManagerProtocol?, coreDataManager: CoreDataManagerProtocol?) {
        self.menuItem = item
        self.coreDataManager = coreDataManager

        itemNameLabel.text = item.name
        itemPriceLabel.text = "$\(item.price)"

        if let cacheManager {
            cacheManager.loadImage(from: item.imageURL) { [weak self] image in
                guard let self else { return }
                if let image {
                    self.itemImageView.image = image
                }
            }
        }

        updateFavoriteButton()

        favoriteButton.removeTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }

    private func updateFavoriteButton() {
        if let menuItem, let coreDataManager {
            favoriteButton.backgroundColor = coreDataManager.isFavorite(id: menuItem.id) ? .purple : .lightGray
        }

    }
}

// MARK: - Actions
extension TableCardViewCell {
    @objc private func favoriteButtonTapped() {
        if let menuItem, let coreDataManager {
            coreDataManager.toggleFavorite(item: menuItem)

            let isFav = CoreDataManager.shared.isFavorite(id: menuItem.id)
            let newColor: UIColor = isFav ? .purple : .lightGray

            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.5,
                           options: [],
                           animations: {
                self.favoriteButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.favoriteButton.backgroundColor = newColor
            }, completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.favoriteButton.transform = .identity
                }
            })
            NotificationCenter.default.post(name: .favoriteItemUpdated, object: menuItem)
        }
    }
}
