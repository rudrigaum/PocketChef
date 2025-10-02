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
    
    private var searchHistory: [String] = []
    private var searchResults: [PocketChef.MealDetails] = []
    
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
        
        viewModel.loadInitialState()
    }
    
    // MARK - Private Methods
    private func setupUI() {
        title = "Search"
        customView?.tableView.dataSource = self
        customView?.tableView.delegate = self
        customView?.searchBar.delegate = self
        customView?.tableView.register(MealCell.self, forCellReuseIdentifier: MealCell.reuseIdentifier)
        customView?.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
    }

    private func setupBindings() {
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handle(state: state)
            }
            .store(in: &cancellables)
    }
    
    private func handle(state: SearchState) {
        switch state {
        case .idle:
            customView?.activityIndicator.stopAnimating()
            
        case .loading:
            customView?.activityIndicator.startAnimating()
            
        case .showingHistory(let history):
            customView?.activityIndicator.stopAnimating()
            self.searchHistory = history
            self.searchResults = []
            customView?.tableView.reloadData()
            
        case .showingResults(let results):
            customView?.activityIndicator.stopAnimating()
            self.searchHistory = []
            self.searchResults = results
            customView?.tableView.reloadData()
            
        case .error(let message):
            customView?.activityIndicator.stopAnimating()
            print("Search Error: \(message)")
        }
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return !searchResults.isEmpty ? searchResults.count : searchHistory.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !searchResults.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MealCell.reuseIdentifier, for: indexPath) as? MealCell else {
                return UITableViewCell()
            }
            
            let meal = searchResults[indexPath.row]
            let imageURL = URL(string: meal.thumbnailURLString ?? "")
            cell.configure(with: meal.name, imageURL: imageURL)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
            let term = searchHistory[indexPath.row]
            var content = cell.defaultContentConfiguration()
            content.text = term
            cell.contentConfiguration = content
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if !searchResults.isEmpty {
            let selectedMeal = searchResults[indexPath.row]
            delegate?.searchViewController(self, didSelectMeal: selectedMeal)
        } else {
            let selectedTerm = searchHistory[indexPath.row]
            customView?.searchBar.text = selectedTerm
            viewModel.search(for: selectedTerm)
        }
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
