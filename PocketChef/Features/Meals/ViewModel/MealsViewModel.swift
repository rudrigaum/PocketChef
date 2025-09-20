//
//  MealsViewModel.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 20/09/25.
//

import Foundation

final class MealsViewModel: MealsViewModelProtocol {
    
    var onMealsUpdated: (() -> Void)?
    var onFetchError: ((String) -> Void)?
    
    private var meals: [Meal] = []
    private let category: Category
    private let networkService: NetworkServiceProtocol
    private let baseURL = "https://www.themealdb.com/api/json/v1/1/filter.php?c="
    
    init(category: Category, networkService: NetworkServiceProtocol = NetworkService()) {
        self.category = category
        self.networkService = networkService
    }
    
    var screenTitle: String {
        return "\(category.name) Meals"
    }
    
    var numberOfMeals: Int {
        return meals.count
    }
    
    func meal(at index: Int) -> Meal? {
        guard index >= 0 && index < meals.count else {
            return nil
        }
        return meals[index]
    }
    
    func fetchMeals() {
        let urlString = baseURL + category.name
        
        networkService.request(urlString: urlString) { [weak self] (result: Result<MealsResponse, NetworkError>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.meals = response.meals.sorted { $0.name < $1.name }
                self.onMealsUpdated?()
            case .failure(let error):
                self.onFetchError?(error.localizedDescription)
            }
        }
    }
}
