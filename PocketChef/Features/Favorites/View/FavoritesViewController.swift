//
//  FavoritesViewController.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 09/10/25.
//

import Foundation
import UIKit
import Combine

@MainActor
final class FavoritesViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: FavoritesViewModelProtocol
    weak var delegate: FavoritesViewControllerDelegate?

    private var customView: FavoritesView? {
        return view as? FavoritesView
    }
    
    private var favorites: [FavoriteMealInfo] = []
    
    private let emptyStateView = EmptyStateView()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    init(viewModel: FavoritesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func loadView() {
        self.view = FavoritesView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await viewModel.fetchFavorites()
        }
    }
    
    // MARK - Private Methods
    private func setupUI() {
        title = "Favorites"
        customView?.tableView.dataSource = self
        customView?.tableView.delegate = self
        customView?.tableView.register(MealCell.self, forCellReuseIdentifier: MealCell.reuseIdentifier)
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
    
    private func handle(state: FavoritesState) {
        switch state {
        case .loading:
            emptyStateView.isHidden = true
            
        case .loaded(let favorites):
            self.favorites = favorites
            emptyStateView.configure(with: "You have no favorite meals yet.", iconName: "star.slash")
            emptyStateView.isHidden = !favorites.isEmpty
            
        case .error(let message):
            self.favorites = []
            emptyStateView.configure(with: message, iconName: "exclamationmark.triangle")
            emptyStateView.isHidden = false
        }
        customView?.tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MealCell.reuseIdentifier, for: indexPath) as? MealCell else {
            return UITableViewCell()
        }
        let favorite = favorites[indexPath.row]
        let imageURL = URL(string: favorite.thumbnailURLString ?? "")
        cell.configure(with: favorite.name, imageURL: imageURL)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedFavorite = favorites[indexPath.row]
        delegate?.favoritesViewController(self, didSelectFavorite: selectedFavorite)
    }
}
