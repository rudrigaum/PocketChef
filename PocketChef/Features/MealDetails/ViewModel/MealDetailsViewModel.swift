//
//  MealDetailsViewModel.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 22/09/25.
//

import Foundation
import Combine

@MainActor
final class MealDetailsViewModel: MealDetailsViewModelProtocol {
    
    // MARK: - Publishers (Data Binding)
    var detailsPublisher: AnyPublisher<MealDetails, Never> {
        detailsSubject.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<String, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Private Properties
    private let detailsSubject = PassthroughSubject<MealDetails, Never>()
    private let errorSubject = PassthroughSubject<String, Never>()
    
    private let mealSummary: Meal
    private let networkService: NetworkServiceProtocol
    private let baseURL = "https://www.themealdb.com/api/json/v1/1/lookup.php?i="

    // MARK: - Initialization
    init(meal: Meal, networkService: NetworkServiceProtocol = NetworkService()) {
        self.mealSummary = meal
        self.networkService = networkService
    }
    
    // MARK: - Data Source
    var mealName: String {
        return mealSummary.name
    }
    
    var mealThumbnailURL: URL? {
        return URL(string: mealSummary.thumbnailURLString)
    }
    
    // MARK: - View Actions
    func fetchDetails() async {
        let urlString = baseURL + mealSummary.id
        
        do {
            let response: MealDetailsResponse = try await networkService.request(urlString: urlString)
            
            if let details = response.meals.first {
                detailsSubject.send(details)
            } else {
                throw NetworkError.invalidResponse
            }
        } catch {
            errorSubject.send(error.localizedDescription)
        }
    }
}
