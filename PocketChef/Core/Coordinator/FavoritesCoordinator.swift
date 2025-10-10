//
//  FavoritesCoordinator.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 09/10/25.
//

import Foundation
import UIKit

@MainActor
final class FavoritesCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = FavoritesViewModel()
        let viewController = FavoritesViewController(viewModel: viewModel)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: false)
    }
    
    // MARK: - Navigation
    private func showMealDetails(for favorite: FavoriteMealInfo) {
        let mealSummary = Meal(
            id: favorite.id,
            name: favorite.name,
            thumbnailURLString: favorite.thumbnailURLString ?? ""
        )
        
        let viewModel = MealDetailsViewModel(meal: mealSummary)
        let viewController = MealDetailsViewController(viewModel: viewModel)
        viewController.delegate = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - FavoritesViewControllerDelegate
extension FavoritesCoordinator: FavoritesViewControllerDelegate {
    func favoritesViewController(_ controller: FavoritesViewController, didSelectFavorite favorite: FavoriteMealInfo) {
        showMealDetails(for: favorite)
    }
}

// MARK: - MealDetailsViewControllerDelegate
extension FavoritesCoordinator: MealDetailsViewControllerDelegate {
    func mealDetailsViewController(_ controller: MealDetailsViewController, didFailWith error: Error) {
        presentAlert(title: "Error", message: error.localizedDescription)
    }
}
