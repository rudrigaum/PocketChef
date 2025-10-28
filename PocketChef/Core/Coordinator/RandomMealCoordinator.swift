//
//  RandomMealCoordinator.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 26/10/25.
//

import Foundation
import UIKit
import Combine

@MainActor
final class RandomMealCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = RandomMealViewModel()
        let viewController = RandomMealViewController(viewModel: viewModel)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: false)
    }
    
    // MARK: - Navigation
    private func showMealDetails(for mealDetails: MealDetails) {
        let mealSummary = Meal(id: mealDetails.id,
                               name: mealDetails.name,
                               thumbnailURLString: mealDetails.thumbnailURLString ?? "")
        
        let viewModel = MealDetailsViewModel(meal: mealSummary)
        let viewController = MealDetailsViewController(viewModel: viewModel)
        viewController.delegate = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - RandomMealViewControllerDelegate
extension RandomMealCoordinator: RandomMealViewControllerDelegate {
    func randomMealViewController(_ controller: RandomMealViewController, didRequestDetailsFor meal: MealDetails) {
        showMealDetails(for: meal)
    }
    
    func randomMealViewController(_ controller: RandomMealViewController, didFailWith error: Error) {
        presentAlert(title: "Error", message: error.localizedDescription)
    }
}

// MARK: - MealDetailsViewControllerDelegate
extension RandomMealCoordinator: MealDetailsViewControllerDelegate {
    func mealDetailsViewController(_ controller: MealDetailsViewController, didFailWith error: Error) {
        presentAlert(title: "Error", message: error.localizedDescription)
    }
}
