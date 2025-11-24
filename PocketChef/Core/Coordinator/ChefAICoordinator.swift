//
//  ChefAICoordinator.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 21/11/25.
//

import Foundation
import UIKit

@MainActor
public final class ChefAICoordinator: Coordinator {
    
    public var navigationController: UINavigationController
    
    public init() {
        self.navigationController = UINavigationController()
    }
    
    public func start() {
        let apiKey = APIKeyManager.geminiAPIKey
        let geminiService = GeminiAPIService(apiKey: apiKey)
        let viewModel = ChefAIViewModel(geminiService: geminiService)
        let viewController = ChefAIViewController(viewModel: viewModel)
        self.navigationController.setViewControllers([viewController], animated: false)
    }
}
