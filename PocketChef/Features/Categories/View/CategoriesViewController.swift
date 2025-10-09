//
//  CategoriesViewController.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 17/09/25.
//

import Foundation
import UIKit
import Combine

@MainActor
final class CategoriesViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: CategoriesViewModelProtocol
    weak var delegate: CategoriesViewControllerDelegate?
    
    private var customView: CategoriesView? {
        return view as? CategoriesView
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(viewModel: CategoriesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = CategoriesView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        
        setupTableView()
        setupBindings()
        
        customView?.activityIndicator.startAnimating()
        
        Task {
            await viewModel.fetchCategories()
        }
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        customView?.tableView.dataSource = self
        customView?.tableView.delegate = self
        customView?.tableView.register(MealCell.self, forCellReuseIdentifier: "CategoryCell")
    }
    
    private func setupBindings() {
        viewModel.categoriesPublisher
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
                print("Error fetching categories: \(errorMessage)")
            }
            .store(in: &cancellables)
    }
}

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCategories
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        if let category = viewModel.category(at: indexPath.row) {
            var content = cell.defaultContentConfiguration()
            content.text = category.name
            cell.contentConfiguration = content
        }
        
        return cell
    }
}

extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
        guard let selectedCategory = viewModel.category(at: indexPath.row) else {
            return
        }
        
        delegate?.categoriesViewController(self, didSelectCategory: selectedCategory)
    }
}
