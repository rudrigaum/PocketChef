//
//  MealDetailsViewController.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 22/09/25.
//

import Foundation
import UIKit

final class MealDetailsViewController: UIViewController {
    
    private let viewModel: MealDetailsViewModelProtocol
    private var customView: MealDetailsView? {
        return view as? MealDetailsView
    }
    
    init(viewModel: MealDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = MealDetailsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        title = viewModel.mealName
        
        customView?.activityIndicator.startAnimating()
        viewModel.fetchDetails()
    }
    
    private func setupBindings() {
        viewModel.onDetailsUpdated = { [weak self] in
            self?.updateView()
        }
        
        viewModel.onFetchError = { [weak self] errorMessage in
            self?.customView?.activityIndicator.stopAnimating()
            print("Error fetching details: \(errorMessage)")
        }
    }

    private func updateView() {
        guard let customView = self.customView else { return }
        
        customView.activityIndicator.stopAnimating()
        customView.instructionsLabel.text = self.viewModel.instructions
        customView.displayIngredients(self.viewModel.ingredients)
        customView.mealImageView.loadImage(from: self.viewModel.mealThumbnailURL)
    }
}
