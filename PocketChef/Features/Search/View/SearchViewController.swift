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
    
    private let emptyStateView = EmptyStateView()
    private var searchHistory: [String] = []
    private var searchResults: [MealDetails] = []
    private var isLoading: Bool = false
    
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
        customView?.tableView.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.reuseIdentifier)
        customView?.tableView.register(SkeletonCell.self, forCellReuseIdentifier: SkeletonCell.reuseIdentifier)
        customView?.tableView.backgroundView = emptyStateView
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
            renderIdleState()
        case .loading:
            renderLoadingState()
        case .showingHistory(let history):
            renderHistoryState(history: history)
        case .showingResults(let results):
            renderResultsState(results: results)
        case .error(let message):
            renderErrorState(message: message)
        }
        customView?.tableView.reloadData()
    }
    
    // MARK: - State Rendering Helper Methods
    private func renderIdleState() {
            self.isLoading = false
            emptyStateView.isHidden = true
        }
        
        private func renderLoadingState() {
            emptyStateView.isHidden = true
            self.isLoading = true
            searchResults = []
            searchHistory = []
        }
        
        private func renderHistoryState(history: [String]) {
            self.isLoading = false
            searchHistory = history
            searchResults = []
            
            emptyStateView.configure(with: "Your recent searches will appear here.", iconName: "clock")
            emptyStateView.isHidden = !history.isEmpty
        }
        
        private func renderResultsState(results: [MealDetails]) {
            self.isLoading = false
            searchHistory = []
            searchResults = results
            
            if results.isEmpty {
                let searchTerm = customView?.searchBar.text ?? ""
                let message = "No results found for \"\(searchTerm)\".\nPlease try another search."
                emptyStateView.configure(with: message, iconName: "magnifyingglass")
            }
            emptyStateView.isHidden = !results.isEmpty
        }
        
        private func renderErrorState(message: String) {
            self.isLoading = false
            searchHistory = []
            searchResults = []
            
            emptyStateView.configure(with: message, iconName: "exclamationmark.triangle")
            emptyStateView.isHidden = false
        }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 6
        }
        return !searchResults.isEmpty ? searchResults.count : searchHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonCell.reuseIdentifier, for: indexPath) as? SkeletonCell else {
                return UITableViewCell()
            }
            return cell

        } else if !searchResults.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MealCell.reuseIdentifier, for: indexPath) as? MealCell else {
                return UITableViewCell()
            }
            let meal = searchResults[indexPath.row]
            let imageURL = URL(string: meal.thumbnailURLString ?? "")
            cell.configure(with: meal.name, imageURL: imageURL)
            return cell

        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.reuseIdentifier, for: indexPath) as? HistoryCell else {
                return UITableViewCell()
            }
            let term = searchHistory[indexPath.row]
            cell.configure(with: term)
            cell.onDeleteButtonTapped = { [weak self] in
                self?.viewModel.deleteHistory(term: term)
            }
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard !isLoading else { return }

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
