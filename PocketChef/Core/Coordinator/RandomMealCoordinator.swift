//
//  RandomMealCoordinator.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 26/10/25.
//

import Foundation
// Em: Core/Coordinator/RandomMealCoordinator.swift

import UIKit

@MainActor
final class RandomMealCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = UIViewController()
        viewController.title = "Surprise Me!"
        viewController.view.backgroundColor = .systemBackground
        
        navigationController.pushViewController(viewController, animated: false)
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        
        viewController.view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor)
        ])
    }
}
