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
        let viewModel = CategoriesViewModel()
        let viewController = CategoriesViewController(viewModel: viewModel)
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
    
    func categoriesViewController(_ controller: CategoriesViewController, didFailWith error: Error) {
        presentAlert(title: "Error", message: error.localizedDescription)
    }
}

extension MainCoordinator: MealsViewControllerDelegate {
    func mealsViewController(_ controller: MealsViewController, didSelectMeal meal: Meal) {
        showMealDetails(for: meal)
    }
    
    func mealsViewController(_ controller: MealsViewController, didFailWith error: Error) {
          presentAlert(title: "Error", message: error.localizedDescription)
      }
}

extension MainCoordinator {
    func mealDetailsViewController(_ controller: MealDetailsViewController, didFailWith error: Error) {
        presentAlert(title: "Error", message: error.localizedDescription)
    }
}
