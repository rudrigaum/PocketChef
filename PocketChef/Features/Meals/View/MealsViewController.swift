//
//  MealsViewController.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 20/09/25.
//

import Foundation
import UIKit
import Combine

@MainActor
final class MealsViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: MealsViewModelProtocol
    weak var delegate: MealsViewControllerDelegate?

    private var customView: MealsView? {
        return view as? MealsView
    }
    
    private var meals: [Meal] = []
    private var isLoading: Bool = true
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        customView?.tableView.register(SkeletonCell.self, forCellReuseIdentifier: SkeletonCell.reuseIdentifier)
    }

    private func setupBindings() {
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handle(state: state)
            }
            .store(in: &cancellables)
    }
    
    private func handle(state: MealsState) {
        switch state {
        case .loading:
            self.isLoading = true
            customView?.tableView.reloadData()
            
        case .loaded(let meals):
            self.isLoading = false
            self.meals = meals
            customView?.tableView.reloadData()
            
        case .error(let error):
            self.isLoading = false
            self.meals = []
            customView?.tableView.reloadData()
            delegate?.mealsViewController(self, didFailWith: error)
        }
    }
}

// MARK: - UITableViewDataSource
extension MealsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? 6 : meals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonCell.reuseIdentifier, for: indexPath) as? SkeletonCell else {
                return UITableViewCell()
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MealCell.reuseIdentifier, for: indexPath) as? MealCell else {
                return UITableViewCell()
            }
            
            let meal = meals[indexPath.row]
            let imageURL = URL(string: meal.thumbnailURLString)
            cell.configure(with: meal.name, imageURL: imageURL)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension MealsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard !isLoading else { return }
        let selectedMeal = meals[indexPath.row]
        delegate?.mealsViewController(self, didSelectMeal: selectedMeal)
    }
}
