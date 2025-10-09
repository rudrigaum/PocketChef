//
//  MealDetailsViewController.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 22/09/25.
//

import Foundation
import UIKit
import Combine

final class MealDetailsViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: MealDetailsViewModelProtocol
    private var customView: MealDetailsView? {
        return view as? MealDetailsView
    }
    
    private var cancellables = Set<AnyCancellable>()
    private var favoriteButton: UIBarButtonItem?
    
    // MARK: - Initialization
    init(viewModel: MealDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = MealDetailsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        setupFavoriteButton()
        
        title = viewModel.mealName
        customView?.activityIndicator.startAnimating()
        
        Task {
            await viewModel.fetchDetails()
        }
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        viewModel.detailsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] mealDetails in
                self?.updateView(with: mealDetails)
            }
            .store(in: &cancellables)
            
        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.customView?.activityIndicator.stopAnimating()
                print("Error fetching details: \(errorMessage)")
            }
            .store(in: &cancellables)
        
        viewModel.isFavoritePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isFavorite in
                self?.updateFavoriteButton(isFavorite: isFavorite)
            }
            .store(in: &cancellables)
    }
    
    private func updateView(with details: MealDetails) {
        guard let customView = self.customView else { return }
        
        customView.activityIndicator.stopAnimating()
        customView.instructionsLabel.text = details.instructions
        customView.displayIngredients(details.ingredients)
        let imageURL = URL(string: details.thumbnailURLString ?? "")
        ImageLoader.shared.loadImage(into: customView.mealImageView, from: imageURL)
    }
    
    private func setupFavoriteButton() {
        let button = UIBarButtonItem(image: UIImage(systemName: "star"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(favoriteButtonTapped))
        navigationItem.rightBarButtonItem = button
        self.favoriteButton = button
    }

    @objc private func favoriteButtonTapped() {
        Task {
            await viewModel.toggleFavoriteStatus()
        }
    }
    
    private func updateFavoriteButton(isFavorite: Bool) {
        let iconName = isFavorite ? "star.fill" : "star"
        favoriteButton?.image = UIImage(systemName: iconName)
    }
}
