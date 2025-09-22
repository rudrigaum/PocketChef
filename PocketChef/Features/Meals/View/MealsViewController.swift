//
//  MealsViewController.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 20/09/25.
//

import Foundation
import UIKit

final class MealsViewController: UIViewController {
    
    private let viewModel: MealsViewModelProtocol
    weak var delegate: MealsViewControllerDelegate?
    private var customView: MealsView? {
        return view as? MealsView
    }
    
    init(viewModel: MealsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = MealsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTableView()
        setupBindings()
        
        customView?.activityIndicator.startAnimating()
        viewModel.fetchMeals()
    }
    
    private func setupView() {
        title = viewModel.screenTitle
    }
    
    private func setupTableView() {
        customView?.tableView.dataSource = self
        customView?.tableView.delegate = self
    }
    
    private func setupBindings() {
        viewModel.onMealsUpdated = { [weak self] in
            self?.customView?.tableView.reloadData()
            self?.customView?.activityIndicator.stopAnimating()
        }
        
        viewModel.onFetchError = { [weak self] errorMessage in
            print("Error fetching meals: \(errorMessage)")
            self?.customView?.activityIndicator.stopAnimating()
        }
    }
}

extension MealsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMeals
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath)
        
        if let meal = viewModel.meal(at: indexPath.row) {
            var content = cell.defaultContentConfiguration()
            content.text = meal.name
            cell.contentConfiguration = content
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
