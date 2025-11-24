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
    
    private var categories: [Category] = []
    private var isLoading: Bool = true
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
        setupUI()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await viewModel.fetchCategories()
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        title = "Categories"
        customView?.tableView.dataSource = self
        customView?.tableView.delegate = self
        customView?.tableView.register(MealCell.self, forCellReuseIdentifier: MealCell.reuseIdentifier)
        customView?.tableView.register(SkeletonCell.self, forCellReuseIdentifier: SkeletonCell.reuseIdentifier)
        
        let surpriseButton = UIBarButtonItem(
            image: UIImage(systemName: "dice"),
            style: .plain,
            target: self,
            action: #selector(surpriseButtonTapped)
        )
        surpriseButton.accessibilityLabel = "Surprise Me"
        navigationItem.rightBarButtonItem = surpriseButton
    }

    private func setupBindings() {
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handle(state: state)
            }
            .store(in: &cancellables)
    }
    
    @objc private func surpriseButtonTapped() {
        delegate?.categoriesViewControllerDidTapSurpriseMe(self)
    }
    
    private func handle(state: CategoriesState) {
        switch state {
        case .loading:
            self.isLoading = true
            customView?.tableView.reloadData()
            
        case .loaded(let categories):
            self.isLoading = false
            self.categories = categories
            customView?.tableView.reloadData()
            
        case .error(let error):
            self.isLoading = false
            self.categories = []
            customView?.tableView.reloadData()
            delegate?.categoriesViewController(self, didFailWith: error)
        }
    }
}

// MARK: - UITableViewDataSource
extension CategoriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? 6 : categories.count
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
            
            let category = categories[indexPath.row]
            let imageURL = URL(string: category.thumbnailURL)
            cell.configure(with: category.name, imageURL: imageURL)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension CategoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard !isLoading else { return }
        let selectedCategory = categories[indexPath.row]
        delegate?.categoriesViewController(self, didSelectCategory: selectedCategory)
    }
}
