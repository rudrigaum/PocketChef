//
//  SearchCoordinator.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 24/09/25.
//

import Foundation
import UIKit

@MainActor
final class SearchCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = SearchViewModel()
        let searchViewController = SearchViewController(viewModel: viewModel)
        searchViewController.delegate = self
        navigationController.pushViewController(searchViewController, animated: false)
    }
    
    func showMealDetails(for meal: MealDetails) {
        let mealSummary = Meal(
            id: meal.id,
            name: meal.name,
            thumbnailURLString: meal.thumbnailURLString ?? ""
        )
        
        let viewModel = MealDetailsViewModel(meal: mealSummary)
        let viewController = MealDetailsViewController(viewModel: viewModel)
        viewController.delegate = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - SearchViewControllerDelegate
extension SearchCoordinator: SearchViewControllerDelegate {
    func searchViewController(_ controller: SearchViewController, didSelectMeal meal: MealDetails) {
        showMealDetails(for: meal)
    }
}

// MARK: - MealDetailsViewControllerDelegate
extension SearchCoordinator: MealDetailsViewControllerDelegate {
    func mealDetailsViewController(_ controller: MealDetailsViewController, didFailWith error: Error) {
        presentAlert(title: "Error", message: error.localizedDescription)
    }
}
