//
//  RandomMealViewModel.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 26/10/25.
//

import Foundation
import Combine

@MainActor
final class RandomMealViewModel: RandomMealViewModelProtocol {
    
    // MARK: - Publishers
    var statePublisher: AnyPublisher<RandomMealState, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Private Properties
    private let stateSubject = CurrentValueSubject<RandomMealState, Never>(.idle)
    private let networkService: NetworkServiceProtocol
    private let randomMealURL = "https://www.themealdb.com/api/json/v1/1/random.php"

    // MARK: - Initialization
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - View Actions
    func fetchRandomMeal() async {
        stateSubject.send(.loading)
        
        do {
            let response: MealDetailsResponse = try await networkService.request(urlString: randomMealURL)
            
            guard let mealDetails = response.meals?.first else {
                throw NetworkError.invalidResponse
            }
            
            stateSubject.send(.loaded(mealDetails))
            
        } catch {
            stateSubject.send(.error(error))
        }
    }
}
