//
//  MainCoordinator.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 20/09/25.
//

import Foundation
import UIKit

@MainActor
final class MainCoordinator: Coordinator {
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
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showMealDetails(for meal: Meal) {
        let viewModel = MealDetailsViewModel(meal: meal)
        let viewController = MealDetailsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension MainCoordinator: CategoriesViewControllerDelegate {
    func categoriesViewController(_ controller: CategoriesViewController, didSelectCategory category: Category) {
        showMeals(for: category)
    }
}

extension MainCoordinator: MealsViewControllerDelegate {
    func mealsViewController(_ controller: MealsViewController, didSelectMeal meal: Meal) {
        showMealDetails(for: meal)
    }
}
