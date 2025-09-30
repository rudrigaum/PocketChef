//
//  MealsViewController.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 20/09/25.
//

import Foundation
import UIKit
import Combine

final class MealsViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: MealsViewModelProtocol
    weak var delegate: MealsViewControllerDelegate?

    private var customView: MealsView? {
        return view as? MealsView
    }

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    init(viewModel: MealsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func loadView() {
        self.view = MealsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()

        customView?.activityIndicator.startAnimating()
        
        Task {
            await viewModel.fetchMeals()
        }
    }

    // MARK: - Private Methods
    private func setupUI() {
        title = viewModel.screenTitle
        customView?.tableView.dataSource = self
        customView?.tableView.delegate = self
        customView?.tableView.register(MealCell.self, forCellReuseIdentifier: MealCell.reuseIdentifier)
    }

    private func setupBindings() {
        viewModel.mealsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.customView?.activityIndicator.stopAnimating()
                self?.customView?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.customView?.activityIndicator.stopAnimating()
                print("Error fetching meals: \(errorMessage)")
            }
            .store(in: &cancellables)
    }
}

extension MealsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMeals
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MealCell.reuseIdentifier, for: indexPath) as? MealCell else {
            return UITableViewCell()
        }
        
        if let meal = viewModel.meal(at: indexPath.row) {
            let imageURL = URL(string: meal.thumbnailURLString)
            cell.configure(with: meal.name, imageURL: imageURL)
        }
        
        return cell
    }
}

extension MealsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let selectedMeal = viewModel.meal(at: indexPath.row) else { return }
        
        delegate?.mealsViewController(self, didSelectMeal: selectedMeal)
    }
}
