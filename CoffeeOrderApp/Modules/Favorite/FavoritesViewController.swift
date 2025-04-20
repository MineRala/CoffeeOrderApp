//
//  FavoritesViewController.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 18.04.2025.
//

import UIKit
import SnapKit

final class FavoritesViewController: UIViewController {
    // MARK: - Properties
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = AppString.searchInFavorites.localized
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private lazy var favoritesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(TableCardViewCell.self, forCellReuseIdentifier: AppString.favoriteItemCell)
        return tableView
    }()

    private lazy var emptyView: EmptyFavoriteView = {
        let view = EmptyFavoriteView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var viewModel: FavoritesViewModelProtocol

    init(viewModel: FavoritesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        addNotificationObserver()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavorites()
    }
}

// MARK: - UI
extension FavoritesViewController {
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = AppString.favorites.localized
        setupSearchBar()
        setupTableView()
        setupFavoriteEmptyView()
        updateViewVisibility()
    }

    private func setupSearchBar() {
        view.addSubview(searchBar)

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalTo(view)
        }
    }

    private func setupTableView() {
        view.addSubview(favoritesTableView)

        favoritesTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalTo(view)
        }
    }

    private func setupFavoriteEmptyView() {
        view.addSubview(emptyView)
        emptyView.isHidden = true

        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(favoritesTableView)
        }
    }

    private func updateViewVisibility() {
        let hasFavorites = viewModel.allFavoritesCount > 0
        favoritesTableView.isHidden = !hasFavorites
        emptyView.isHidden = hasFavorites
    }
}

// MARK: - Logic
extension FavoritesViewController {
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshFavorites(_:)), name: .favoriteItemUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showAddToast(_:)), name: .cartItemAdded, object: nil)
    }

    private func fetchFavorites() {
        viewModel.fetchFavorites(text: searchBar.text ?? "")
    }

    private func bindViewModel() {
        viewModel.onFavoritesRemoved = { [weak self] index in
            guard let self else { return }

            let indexPath = IndexPath(row: index, section: 0)
            DispatchQueue.main.async {
                self.favoritesTableView.performBatchUpdates({
                    self.favoritesTableView.deleteRows(at: [indexPath], with: .automatic)
                    self.updateViewVisibility()
                }, completion: nil)
            }
        }

        viewModel.onReloadData = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.favoritesTableView.reloadData()
                self.updateViewVisibility()
            }
        }
    }
}

// MARK: - Actions
extension FavoritesViewController {
    @objc private func refreshFavorites(_ notification: Notification) {
        guard let updatedItem = notification.object as? MenuItem else { return }
        viewModel.refreshFavorites(with: updatedItem)
    }

    @objc private func showAddToast(_ notification: Notification) {
        showSnackBar(message: AppString.addedCard.localized)
    }
}

// MARK: - Present
extension FavoritesViewController {
    private func navigateToDetailViewController(with item: MenuItem) {
        let detailVC = DetailViewController(viewModel: DetailViewModel(menuItem: item, userDefaultsManager: self.viewModel.userDefaultsManager, cacheManager: self.viewModel.cacheManager))
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredFavoritesCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppString.favoriteItemCell, for: indexPath) as? TableCardViewCell else {
            return UITableViewCell()
        }
        let favorite = viewModel.getFavorite(index: indexPath.row)
        cell.configure(with: favorite, cacheManager: viewModel.cacheManager, coreDataManager: viewModel.coreDataManager)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRowAt
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let favoriteItem = viewModel.getFavorite(index: indexPath.row)
        navigateToDetailViewController(with: favoriteItem)
        print("Selected favorite item: \(favoriteItem.name)")
    }
}

// MARK: - UISearchBarDelegate
extension FavoritesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchBar(with: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.searchBar(with: "")
    }
}
