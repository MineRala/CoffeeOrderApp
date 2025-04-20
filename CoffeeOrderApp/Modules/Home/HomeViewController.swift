//
//  HomeViewController.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 18.04.2025.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {

    // MARK:  Properties
    private lazy var bannerView: BannerView = {
        let bannerView = BannerView(images: viewModel.bannerImages)
        return bannerView
    }()

    private lazy var categoryButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private lazy var logoutButton: UIBarButtonItem = {
        let logoutImage = Images.rectanglePortrait
        let button = UIBarButtonItem(
            image: logoutImage,
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
        button.tintColor = .systemPurple
        return button
    }()

    private var itemsCollectionView: UICollectionView!
    private var viewModel: HomeViewModelProtocol

    // MARK:  Initializer
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK:  Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
        addNotificationObserver()
    }
}

// MARK: - UI
extension HomeViewController {
    private func setupUI() {
        setupViewBackground()
        setupNavigationBar()
        setupBannerView()
        setupCategoryButtonStackView()
        setupItemsCollectionView()
    }

    private func setupViewBackground() {
        view.backgroundColor = .white
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = logoutButton
    }

    private func setupBannerView() {
        view.addSubview(bannerView)
        bannerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.25)
        }
    }

    private func setupItemsCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = calculateItemSize()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)

        itemsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        itemsCollectionView.register(CollectionCardViewCell.self, forCellWithReuseIdentifier: AppString.collectionCardCell)
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        itemsCollectionView.backgroundColor = .clear

        view.addSubview(itemsCollectionView)
        itemsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryButtonStackView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
        }
    }

    private func createCategoryButton(for category: Category, at index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(category.title, for: .normal)
        button.tag = index
        button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemPurple.cgColor
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setTitleColor(.systemPurple, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }

    private func setupCategoryButtonStackView() {
        categoryButtonStackView.arrangedSubviews.forEach { $0.removeFromSuperview() } // Eski butonları sıfırla
        for (index, category) in Category.allCases.enumerated() {
            let button = createCategoryButton(for: category, at: index)
            categoryButtonStackView.addArrangedSubview(button)
        }

        highlightSelectedCategoryButton()

        view.addSubview(categoryButtonStackView)
        categoryButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(40)
        }
    }

    private func highlightSelectedCategoryButton() {
        if let selectedButton = categoryButtonStackView.arrangedSubviews[viewModel.selectedCategoryIndex] as? UIButton {
            selectedButton.layer.borderColor = UIColor.purple.cgColor
            selectedButton.setTitleColor(.white, for: .normal)
            selectedButton.backgroundColor = .purple
        }
    }

    private func resetCategoryButtonStyles() {
        for button in categoryButtonStackView.arrangedSubviews as! [UIButton] {
            button.layer.borderColor = UIColor.systemPurple.cgColor
            button.setTitleColor(.systemPurple, for: .normal)
            button.backgroundColor = .clear
        }
    }

}

// MARK: - Logic
extension HomeViewController {
    private func fetchData() {
        viewModel.fetchData()
    }
}

// MARK: - Helpers
extension HomeViewController {
    private func calculateItemSize() -> CGSize {
        let itemWidth = (view.frame.width - 50) / 2
        let itemHeight = itemWidth * 1.3
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

// MARK: - Notifications
extension HomeViewController {
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshFavorites(_:)), name: .favoriteItemUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showAddToast(_:)), name: .cartItemAdded, object: nil)
    }
}

// MARK: - Actions
extension HomeViewController {
    @objc private func logoutTapped() {
        viewModel.logout()

    }

    @objc private func categoryButtonTapped(_ sender: UIButton) {
        viewModel.categoryButtonTapped(at: sender.tag)

        resetCategoryButtonStyles()
        highlightSelectedCategoryButton()

        itemsCollectionView.reloadData()
    }

    @objc private func refreshFavorites(_ notification: Notification) {
        guard let updatedItem = notification.object as? MenuItem else { return }
        viewModel.refreshFavorites(updatedItem: updatedItem)
    }

    @objc private func showAddToast(_ notification: Notification) {
        showSnackBar(message: AppString.addedCard.localized)
    }
}

// MARK: - Present
extension HomeViewController {
    private func navigateToDetailViewController(with item: MenuItem) {
        let detailVC = DetailViewController(menuItem: item)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredMenuItemsCount
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let menuItem = viewModel.getItem(index: indexPath.row)
        navigateToDetailViewController(with: menuItem)
        print("Selected menu item: \(menuItem.name)")
       }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppString.collectionCardCell, for: indexPath) as? CollectionCardViewCell else {
            return UICollectionViewCell()
        }
        let menuItem = viewModel.getItem(index: indexPath.row)
        cell.configure(with: menuItem)
        return cell
    }
}

// MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    func reloadItems(at indexPath: IndexPath) {
        itemsCollectionView.reloadItems(at: [indexPath])
    }

    func didLogoutSuccessfully() {
        let loginViewModel = LoginViewModel(keychainManager: self.viewModel.keychainManager, networkManager: self.viewModel.networkManager)
           let loginVC = LoginViewController(viewModel: loginViewModel)
           let navController = UINavigationController(rootViewController: loginVC)

           navController.modalPresentationStyle = .fullScreen
           self.present(navController, animated: true, completion: nil)
       }

    func didFetchDataSuccessfully() {
         self.itemsCollectionView.reloadData()
     }

    func didFailToFetchData(with error: AppError) {
        self.showAlert(title: AppString.error.localized, message: error.localizedDescription)
         print("Error occurred: \(error.localizedDescription)")
     }
}

