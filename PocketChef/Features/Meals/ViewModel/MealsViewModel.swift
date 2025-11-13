//
//  MealsViewModel.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 20/09/25.
//

import Foundation
import Combine

@MainActor
final class MealsViewModel: MealsViewModelProtocol {
    
    // MARK: - Publishers
    var statePublisher: AnyPublisher<MealsState, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Public Properties
    var screenTitle: String {
        return "\(category.name) Meals"
    }
    
    // MARK: - Private Properties
    private let stateSubject = CurrentValueSubject<MealsState, Never>(.loading)
    private let category: Category
    private let networkService: NetworkServiceProtocol
    private let baseURL = "https://www.themealdb.com/api/json/v1/1/filter.php?c="

    // MARK: - Initialization
    init(category: Category, networkService: NetworkServiceProtocol = NetworkService()) {
        self.category = category
        self.networkService = networkService
    }
    
    // MARK: - View Actions
    func fetchMeals() async {
        stateSubject.send(.loading)
        
        let urlString = baseURL + category.name
        
        do {
            let response: MealsResponse = try await networkService.request(urlString: urlString)
            let meals = response.meals.sorted { $0.name < $1.name }
            stateSubject.send(.loaded(meals))
            
        } catch {
            stateSubject.send(.error(error))
        }
    }
}
