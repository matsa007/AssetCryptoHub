//
//  SceneDelegate.swift
//  AssetCryptoHub
//
//  Created by Сергей Матвеенко on 25.02.24.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Parameters

    var window: UIWindow?
    private lazy var tabBarVC: UITabBarController = {
        let vc = UITabBarController()
        vc.tabBar.tintColor = .black
        vc.tabBar.backgroundColor = ColorsSet.tabBarBackgroundColor
        vc.tabBar.isTranslucent = true
        return vc
    }()
    
    private let mainScreenInfoVC = UINavigationController(
        rootViewController: MainCryptoInfoViewController()
    )
    private let portfolioVC = UINavigationController(
        rootViewController: MainPortfolioViewController()
    )
    
    // MARK: - Set view scene

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        self.setTabBarController()
        self.addViewControllers()
        window?.rootViewController = self.tabBarVC
        window?.makeKeyAndVisible()
    }
    
    // MARK: - Set tab bar controller
    
    private func setTabBarController() {
        self.mainScreenInfoVC.tabBarItem = UITabBarItem(
            title: Titles.cryptoInfoTitle,
            image: UIImage(systemName: ImageNames.priceQuotes),
            selectedImage: nil
        )
        self.portfolioVC.tabBarItem = UITabBarItem(
            title: Titles.portfolioTitle,
            image: UIImage(systemName: ImageNames.portfolio),
            selectedImage: nil
        )
    }
    
    // MARK: - Add view controllers
    
    private func addViewControllers() {
        self.tabBarVC.setViewControllers([
            self.mainScreenInfoVC,
            self.portfolioVC
        ], animated: true)
        
        self.tabBarVC.selectedViewController = self.mainScreenInfoVC
    }
}

