//
//  MainCoordinator.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 20/09/25.
//

import Foundation
import UIKit

final class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = CategoriesViewController()
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showMeals(for category: Category) {
        print("Coordinator was told to show meals for: \(category.name)")
    }
}
