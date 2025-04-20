//
//  HomeViewModel.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 19.04.2025.
//

import Foundation

protocol HomeViewModelProtocol {
    var networkManager: NetworkManagerProtocol { get }
    var keychainManager: KeychainManagerProtocol { get }
    var userDefaultsManager: UserDefaultsProtocol { get }
    var cacheManager: CacheManagerProtocol { get }
    var coreDataManager: CoreDataManagerProtocol { get }
    var delegate: HomeViewModelDelegate? { get set }

    var filteredMenuItemsCount: Int { get }
    var selectedCategoryIndex: Int { get set }
    var bannerImages: [String] { get }

    func fetchData()
    func refreshFavorites(updatedItem: MenuItem)
    func getItem(index: Int) -> MenuItem
    func categoryButtonTapped(at index: Int)
    func logout()
}

protocol HomeViewModelDelegate: AnyObject {
    func reloadItems(at indexPath: IndexPath)
    func didLogoutSuccessfully()
    func didFetchDataSuccessfully()
    func didFailToFetchData(with error: AppError)
}

final class HomeViewModel {
    private var menuItems: [MenuItem] = []
    private var filteredMenuItems: [MenuItem] = []
    var selectedCategoryIndex: Int = 0
    var bannerImages: [String] = [AppString.banner1, AppString.banner2, AppString.banner3]

    public let keychainManager: KeychainManagerProtocol
    public let networkManager: NetworkManagerProtocol
    public let userDefaultsManager: UserDefaultsProtocol
    public let cacheManager: CacheManagerProtocol
    public let coreDataManager: CoreDataManagerProtocol

    public weak var delegate: HomeViewModelDelegate?

    init(keychainManager: KeychainManagerProtocol, networkManager: NetworkManagerProtocol, userDefaultsManager: UserDefaultsProtocol, cacheManager: CacheManagerProtocol, coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.keychainManager = keychainManager
        self.networkManager = networkManager
        self.userDefaultsManager = userDefaultsManager
        self.cacheManager = cacheManager
        self.coreDataManager = coreDataManager
    }
}

// MARK: - Private
extension HomeViewModel {
    private func updateItemsForSelectedCategory() {
        let category = Category.allCases[selectedCategoryIndex]
        filteredMenuItems = category.items(from: menuItems)
    }
}

// MARK: - HomeViewModelProtocol
extension HomeViewModel: HomeViewModelProtocol {
    var filteredMenuItemsCount: Int {
        filteredMenuItems.count
    }

    func fetchData() {
        networkManager.loadLocalJSON(filename: AppString.menuData, type: MenuResponse.self) { result in
            switch result {
            case .success(let response):
                self.menuItems = response.items
                self.updateItemsForSelectedCategory()
                self.delegate?.didFetchDataSuccessfully()
            case .failure(let error):
                self.delegate?.didFailToFetchData(with: error)
            }
        }
    }

    func refreshFavorites(updatedItem: MenuItem) {
        if let index = filteredMenuItems.firstIndex(where: { $0.id == updatedItem.id }) {
            filteredMenuItems[index] = updatedItem
            let indexPath = IndexPath(row: index, section: 0)
            delegate?.reloadItems(at: indexPath)
        }
    }

    func getItem(index: Int) -> MenuItem {
        filteredMenuItems[index]
    }

    func categoryButtonTapped(at index: Int) {
        selectedCategoryIndex = index
        updateItemsForSelectedCategory()
    }

    func logout() {
        keychainManager.deleteCredentials()

        delegate?.didLogoutSuccessfully()
    }
}
