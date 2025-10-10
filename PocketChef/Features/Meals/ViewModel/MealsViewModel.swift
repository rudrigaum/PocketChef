//
//  MealsViewModel.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 20/09/25.
//

import Foundation
import Combine

final class MealsViewModel: MealsViewModelProtocol {
    
    // MARK: - Publishers (Data Binding)
    var mealsPublisher: AnyPublisher<[Meal], Never> {
        mealsSubject.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<Error, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Private Properties
    private let mealsSubject = PassthroughSubject<[Meal], Never>()
    private let errorSubject = PassthroughSubject<Error, Never>()
    
    private var meals: [Meal] = []
    private let category: PocketChef.Category
    private let networkService: NetworkServiceProtocol
    private let baseURL = "https://www.themealdb.com/api/json/v1/1/filter.php?c="
    
    // MARK: - Initialization
    init(category: PocketChef.Category, networkService: NetworkServiceProtocol = NetworkService()) {
        self.category = category
        self.networkService = networkService
    }
    
    // MARK: - Data Source
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
    
    // MARK: - View Actions
    func fetchMeals() async {
        let urlString = baseURL + category.name
        
        do {
            let response: MealsResponse = try await networkService.request(urlString: urlString)
            self.meals = response.meals.sorted { $0.name < $1.name }
            mealsSubject.send(self.meals)
        } catch {
            errorSubject.send(error)
        }
    }
}
