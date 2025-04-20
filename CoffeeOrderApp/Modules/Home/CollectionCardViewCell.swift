//
//  CollectionCardViewCell.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 19.04.2025.
//

import UIKit
class CollectionCardViewCell: UICollectionViewCell {

    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .lightGray.withAlphaComponent(0.1)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        button.backgroundColor = .lightGray
        button.setImage(Images.heartFill, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()

    private let itemNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var menuItem: MenuItem?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        itemNameLabel.text = nil
        priceLabel.text = nil
        itemImageView.image = nil
        favoriteButton.backgroundColor = .lightGray

    }

    private func setupUI() {
        contentView.addSubview(cardView)
        cardView.addSubview(itemImageView)
        cardView.addSubview(favoriteButton)
        cardView.addSubview(itemNameLabel)
        cardView.addSubview(priceLabel)

        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        itemImageView.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.top)
            make.left.right.equalTo(cardView)
            make.height.equalTo(cardView.snp.width)
        }

        favoriteButton.snp.makeConstraints { make in
            make.top.equalTo(itemImageView.snp.top).offset(8)
            make.right.equalTo(itemImageView.snp.right).offset(-8)
            make.width.height.equalTo(36)
        }

        itemNameLabel.snp.makeConstraints { make in
            make.top.equalTo(itemImageView.snp.bottom).offset(8)
            make.left.right.equalTo(cardView).inset(8)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(itemNameLabel.snp.bottom).offset(4)
            make.centerX.equalTo(itemNameLabel)
            make.bottom.equalTo(cardView.snp.bottom).offset(-4)
        }
    }

    func configure(with item: MenuItem) {
        self.menuItem = item

        itemNameLabel.text = item.name
        priceLabel.text = "$\(item.price)"

        CacheManager.shared.loadImage(from: item.imageURL) { [weak self] image in
            guard let self = self else { return }
            if let image = image {
                self.itemImageView.image = image
            }
        }

        updateFavoriteButton()
    }

    private func updateFavoriteButton() {
        if let menuItem {
            favoriteButton.backgroundColor = CoreDataManager.shared.isFavorite(id: menuItem.id) ? .purple : .lightGray
        }

    }

    @objc private func favoriteButtonTapped() {
        if let menuItem {
            CoreDataManager.shared.toggleFavorite(item: menuItem)

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
