//
//  TabBarBuilder.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 18.04.2025.
//

import UIKit

struct TabBarBuilder {
    static func build(keychainManager: KeychainManagerProtocol, networkManager: NetworkManagerProtocol, userDefaultsManager: UserDefaultsProtocol, cacheManager: CacheManagerProtocol) -> UITabBarController {
        let tabBarController = UITabBarController()
        let appearance = UITabBar.appearance()
        appearance.tintColor = .systemPurple
        appearance.unselectedItemTintColor = .gray
        appearance.backgroundColor = .white

        let homeViewModel = HomeViewModel(keychainManager: keychainManager, networkManager: networkManager, userDefaultsManager: userDefaultsManager, cacheManager: cacheManager)
        let homeVC = HomeViewController(viewModel: homeViewModel)
        let favoritesViewModel = FavoritesViewModel(userDefaultsManager: userDefaultsManager, cacheManager: cacheManager)
        let favoritesVC = FavoritesViewController(viewModel: favoritesViewModel)
        let cartVC = CartViewController(viewModel: CartViewModel(userDefaultsManager: userDefaultsManager))

        let homeNav = UINavigationController(rootViewController: homeVC)
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        let cartNav = UINavigationController(rootViewController: cartVC)

        homeNav.tabBarItem = UITabBarItem(title: TabItem.home.title, image: TabItem.home.icon, tag: TabItem.home.tag)
        favoritesNav.tabBarItem = UITabBarItem(title: TabItem.favorites.title, image: TabItem.favorites.icon, tag: TabItem.favorites.tag)
        cartNav.tabBarItem = UITabBarItem(title: TabItem.cart.title, image: TabItem.cart.icon, tag: TabItem.cart.tag)

        tabBarController.tabBar.isTranslucent = false
        tabBarController.viewControllers = [homeNav, favoritesNav, cartNav]

        return tabBarController
    }
}
