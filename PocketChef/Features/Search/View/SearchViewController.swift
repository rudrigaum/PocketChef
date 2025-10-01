//
//  SearchViewController.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 24/09/25.
//

import Foundation
import UIKit
import Combine

@MainActor
final class SearchViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: SearchViewModelProtocol
    weak var delegate: SearchViewControllerDelegate?

    private var customView: SearchView? {
        return view as? SearchView
    }

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func loadView() {
        self.view = SearchView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
    }
    
    // MARK - Private Methods
    private func setupUI() {
        title = "Search"
        customView?.tableView.dataSource = self
        customView?.tableView.delegate = self
        customView?.searchBar.delegate = self
        customView?.tableView.register(MealCell.self, forCellReuseIdentifier: MealCell.reuseIdentifier)
    }

    private func setupBindings() {
        viewModel.searchResultsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.customView?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                print("Search Error: \(errorMessage)")
            }
            .store(in: &cancellables)
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

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let selectedMeal = viewModel.result(at: indexPath.row) else { return }
        
        delegate?.searchViewController(self, didSelectMeal: selectedMeal)
    }
}


// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            viewModel.search(for: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
