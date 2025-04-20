//
//  AppDelegate.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 18.04.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        let keychainManager = KeychainManager()
        let networkManager = NetworkManager()
            let userDefaultsManager = UserDefaultsManager()

        let initialViewController: UIViewController

        if keychainManager.isUserLoggedIn() {
            initialViewController = TabBarBuilder.build(keychainManager: keychainManager, networkManager: networkManager, userDefaultsManager: userDefaultsManager)
        } else {
            let loginViewModel = LoginViewModel(keychainManager: keychainManager, networkManager: networkManager, userDefaultsManager: userDefaultsManager)
            let loginViewController = LoginViewController(viewModel: loginViewModel)
            initialViewController = UINavigationController(rootViewController: loginViewController)
        }

        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()

        return true
    }
}
