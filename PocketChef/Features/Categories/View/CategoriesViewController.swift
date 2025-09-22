//
//  CategoriesViewController.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 17/09/25.
//

import Foundation
import UIKit

final class CategoriesViewController: UIViewController {
    
    private let viewModel: CategoriesViewModelProtocol
    weak var delegate: CategoriesViewControllerDelegate? 
    
    private var customView: CategoriesView? {
        return view as? CategoriesView
    }
    
    
    init(viewModel: CategoriesViewModelProtocol = CategoriesViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = CategoriesView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        
        setupTableView()
        setupBindings()
        
        customView?.activityIndicator.startAnimating()
        viewModel.fetchCategories()
    }
    
    // MARK: - Private Methods
    
    private func setupTableView() {
        customView?.tableView.dataSource = self
        customView?.tableView.delegate = self
    }
    
    private func setupBindings() {
        viewModel.onCategoriesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.customView?.tableView.reloadData()
                self?.customView?.activityIndicator.stopAnimating()
            }
        }
        
        viewModel.onFetchError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                print("Error fetching categories: \(errorMessage)")
                self?.customView?.activityIndicator.stopAnimating()
            }
        }
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
