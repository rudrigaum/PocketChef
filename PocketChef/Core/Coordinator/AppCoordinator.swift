//
//  AppCoordinator.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 24/09/25.
//

import UIKit

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
        
        let searchViewController = UIViewController()
        searchViewController.view.backgroundColor = .systemBackground
        let searchTabIcon = UIImage(systemName: "magnifyingglass")
        searchViewController.tabBarItem = UITabBarItem(title: "Search", image: searchTabIcon, tag: 1)
        
        tabBarController.viewControllers = [categoriesTab, searchViewController]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
