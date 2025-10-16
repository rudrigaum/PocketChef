//
//  VideosCoordinator.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 16/10/25.
//

import Foundation
import UIKit

@MainActor
final class VideosCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = UIViewController()
        viewController.title = "Recipe Videos"
        viewController.view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "Recipe Videos - Coming Soon!"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        viewController.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor)
        ])
        
        navigationController.pushViewController(viewController, animated: false)
    }
}
