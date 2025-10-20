//
//  AppCoordinator.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 24/09/25.
//

import UIKit

@MainActor
final class AppCoordinator: Coordinator {
    
    let window: UIWindow
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        let tabBarController = UITabBarController()
        
        let categoriesTab = setupTab(
            with: MainCoordinator(navigationController: UINavigationController()),
            title: "Categories",
            iconName: "fork.knife",
            tag: 0
        )
        
        let searchTab = setupTab(
            with: SearchCoordinator(navigationController: UINavigationController()),
            title: "Search",
            iconName: "magnifyingglass",
            tag: 1
        )
        
        let favoritesTab = setupTab(
            with: FavoritesCoordinator(navigationController: UINavigationController()),
            title: "Favorites",
            iconName: "star.fill",
            tag: 2
        )
        
        let videosTab = setupTab(
            with: VideosCoordinator(navigationController: UINavigationController()),
            title: "Videos",
            iconName: "play.tv",
            tag: 3
        )
        
        tabBarController.viewControllers = [categoriesTab, searchTab, favoritesTab, videosTab]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    private func setupTab(with coordinator: Coordinator, title: String, iconName: String, tag: Int) -> UINavigationController {
        childCoordinators.append(coordinator)
        coordinator.start()
        
        let navigationController = coordinator.navigationController
        let tabIcon = UIImage(systemName: iconName)
        navigationController.tabBarItem = UITabBarItem(title: title, image: tabIcon, tag: tag)
        
        return navigationController
    }
}
