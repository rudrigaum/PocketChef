//
//  CategoriesViewModel.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 17/09/25.
//

import Foundation

final class CategoriesViewModel: CategoriesViewModelProtocol {
    
    var onCategoriesUpdated: (() -> Void)?
    var onFetchError: ((String) -> Void)?
    
    private var categories: [Category] = []
    private let networkService: NetworkServiceProtocol
    private let categoriesURL = "https://www.themealdb.com/api/json/v1/1/categories.php"
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    var numberOfCategories: Int {
        return categories.count
    }
    
    func category(at index: Int) -> Category? {
        guard index >= 0 && index < categories.count else {
            return nil
        }
        return categories[index]
    }
    
    func fetchCategories() {
        networkService.request(urlString: categoriesURL) { [weak self] (result: Result<CategoriesResponse, NetworkError>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.categories = response.categories
                    self.onCategoriesUpdated?()
                case .failure(let error):
                    self.onFetchError?(error.localizedDescription)
                }
            }
        }
    }
}
