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
        
        let mainCoordinator = MainCoordinator(navigationController: UINavigationController())
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
        
        let categoriesTab = mainCoordinator.navigationController
        let categoriesTabIcon = UIImage(systemName: "fork.knife")
        categoriesTab.tabBarItem = UITabBarItem(title: "Categories", image: categoriesTabIcon, tag: 0)
        
        let searchCoordinator = SearchCoordinator(navigationController: UINavigationController())
        
        childCoordinators.append(searchCoordinator)
        
        searchCoordinator.start()
        
        let searchTab = searchCoordinator.navigationController
        let searchTabIcon = UIImage(systemName: "magnifyingglass")
        searchTab.tabBarItem = UITabBarItem(title: "Search", image: searchTabIcon, tag: 1)
        
        let favoritesCoordinator = FavoritesCoordinator(navigationController: UINavigationController())
        childCoordinators.append(favoritesCoordinator)
        favoritesCoordinator.start()
        
        let favoritesTab = favoritesCoordinator.navigationController
        let favoritesTabIcon = UIImage(systemName: "star.fill")
        favoritesTab.tabBarItem = UITabBarItem(title: "Favorites", image: favoritesTabIcon, tag: 2)
        
        tabBarController.viewControllers = [categoriesTab, searchTab, favoritesTab]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

    }
}
