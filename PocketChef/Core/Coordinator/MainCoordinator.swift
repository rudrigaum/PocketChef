//
//  MainCoordinator.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 20/09/25.
//

import Foundation
import UIKit

final class MainCoordinator: Coordinator, CategoriesViewControllerDelegate {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = CategoriesViewController()
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showMeals(for category: Category) {
        let viewModel = MealsViewModel(category: category)
        let viewController = MealsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension MainCoordinator {
    func categoriesViewController(_ controller: CategoriesViewController, didSelectCategory category: Category) {
        showMeals(for: category)
    }
}
