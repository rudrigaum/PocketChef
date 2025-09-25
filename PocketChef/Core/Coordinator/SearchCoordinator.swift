//
//  SearchCoordinator.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 24/09/25.
//

import Foundation
import UIKit

final class SearchCoordinator: Coordinator, SearchViewControllerDelegate {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let searchViewController = SearchViewController()
        searchViewController.delegate = self
        navigationController.pushViewController(searchViewController, animated: false)
    }
    
    func showMealDetails(for meal: MealDetails) {
        let mealSummary = Meal(id: meal.id,
                               name: meal.name,
                               thumbnailURLString: meal.thumbnailURLString ?? "")
        
        let viewModel = MealDetailsViewModel(meal: mealSummary)
        let viewController = MealDetailsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension SearchCoordinator {
    func searchViewController(_ controller: SearchViewController, didSelectMeal meal: MealDetails) {
        showMealDetails(for: meal)
    }
}
