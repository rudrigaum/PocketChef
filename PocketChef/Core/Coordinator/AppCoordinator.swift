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
        let rootViewController = UIViewController()
        rootViewController.view.backgroundColor = .systemTeal
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
