//
//  TabBarBuilder.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 18.04.2025.
//

import UIKit


struct TabBarBuilder {

    // NetworkManager'ı dışarıdan almak için initializer'ı değiştiriyoruz.
    static func build(keychainManager: KeychainManagerProtocol, networkManager: NetworkManagerProtocol) -> UITabBarController {
        let tabBarController = UITabBarController()
        let appearance = UITabBar.appearance()
        appearance.tintColor = .systemPurple
        appearance.unselectedItemTintColor = .gray
        appearance.backgroundColor = .white

        let homeViewModel = HomeViewModel(keychainManager: keychainManager, networkManager: networkManager)
        let homeVC = HomeViewController(viewModel: homeViewModel)
        let favoritesViewModel = FavoritesViewModel()
        let favoritesVC = FavoritesViewController(viewModel: favoritesViewModel)
        let cartVC = CartViewController()

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
