//
//  SearchViewController.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 24/09/25.
//

import Foundation
import UIKit

final class SearchViewController: UIViewController {
    
    private let viewModel: SearchViewModelProtocol
    weak var delegate: SearchViewControllerDelegate?
    
    private var customView: SearchView? {
        return view as? SearchView
    }
    
    init(viewModel: SearchViewModelProtocol = SearchViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = SearchView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        title = "Search"
        customView?.tableView.dataSource = self
        customView?.searchBar.delegate = self
        customView?.tableView.delegate = self
        customView?.tableView.register(MealCell.self, forCellReuseIdentifier: MealCell.reuseIdentifier)
    }
    
    private func setupBindings() {
        viewModel.onSearchResultsUpdated = { [weak self] in
            self?.customView?.tableView.reloadData()
        }
        
        viewModel.onFetchError = { [weak self] errorMessage in
            print("Search Error: \(errorMessage)")
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfResults
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MealCell.reuseIdentifier, for: indexPath) as? MealCell else {
            return UITableViewCell()
        }
        
        if let meal = viewModel.result(at: indexPath.row) {
            let imageURL = URL(string: meal.thumbnailURLString ?? "")
            cell.configure(with: meal.name, imageURL: imageURL)
        }
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(for: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selectedMeal = viewModel.result(at: indexPath.row) else { return }
        delegate?.searchViewController(self, didSelectMeal: selectedMeal)
    }
}
