//
//  RandomMealViewController.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 26/10/25.
//

import Foundation
import UIKit
import Combine

@MainActor
final class RandomMealViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: RandomMealViewModelProtocol
    weak var delegate: RandomMealViewControllerDelegate?

    private var customView: RandomMealView? {
        return view as? RandomMealView
    }
    
    private var loadedMeal: MealDetails?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    init(viewModel: RandomMealViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func loadView() {
        self.view = RandomMealView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Surprise Me!"
        setupBindings()
        setupActions()
    }

    // MARK: - Private Methods
    private func setupBindings() {
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handle(state: state)
            }
            .store(in: &cancellables)
    }
    
    private func setupActions() {
        customView?.surpriseMeButton.addTarget(self, action: #selector(surpriseMeButtonTapped), for: .touchUpInside)
        customView?.viewDetailsButton.addTarget(self, action: #selector(viewDetailsButtonTapped), for: .touchUpInside)
    }
    
    private func handle(state: RandomMealState) {
        switch state {
        case .idle:
            title = "Surprise Me!"
            customView?.activityIndicator.stopAnimating()
            customView?.surpriseMeButton.isHidden = false
            customView?.viewDetailsButton.isHidden = true
            
            let config = UIImage.SymbolConfiguration(pointSize: 80, weight: .light)
            customView?.mealImageView.image = UIImage(systemName: "dice", withConfiguration: config)
            customView?.mealImageView.tintColor = .systemGray3
            
        case .loading:
            customView?.activityIndicator.startAnimating()
            customView?.surpriseMeButton.isHidden = true
            customView?.viewDetailsButton.isHidden = true
            
        case .loaded(let mealDetails):
            customView?.activityIndicator.stopAnimating()
            
            self.loadedMeal = mealDetails
            navigationItem.title = mealDetails.name
            
            let imageURL = URL(string: mealDetails.thumbnailURLString ?? "")
            ImageLoader.shared.loadImage(into: customView!.mealImageView, from: imageURL)
            
            customView?.surpriseMeButton.isHidden = false
            customView?.viewDetailsButton.isHidden = false
            
        case .error(let error):
            customView?.activityIndicator.stopAnimating()
            customView?.surpriseMeButton.isHidden = false
            customView?.viewDetailsButton.isHidden = true
            delegate?.randomMealViewController(self, didFailWith: error)
        }
    }
    
    @objc private func surpriseMeButtonTapped() {
        Task {
            await viewModel.fetchRandomMeal()
        }
    }
    
    @objc private func viewDetailsButtonTapped() {
        guard let meal = loadedMeal else { return }
        delegate?.randomMealViewController(self, didRequestDetailsFor: meal)
    }
}
