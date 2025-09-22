//
//  MealDetailsViewModel.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 22/09/25.
//

import Foundation

final class MealDetailsViewModel: MealDetailsViewModelProtocol {
    
    var onDetailsUpdated: (() -> Void)?
    var onFetchError: ((String) -> Void)?
    
    private let mealSummary: Meal
    private var mealDetails: MealDetails?
    private let networkService: NetworkServiceProtocol
    private let baseURL = "https://www.themealdb.com/api/json/v1/1/lookup.php?i="

    init(meal: Meal, networkService: NetworkServiceProtocol = NetworkService()) {
        self.mealSummary = meal
        self.networkService = networkService
    }
    
    var mealName: String {
        return mealSummary.name
    }
    
    var mealThumbnailURL: URL? {
        guard let urlString = mealDetails?.thumbnailURLString else {
            return URL(string: mealSummary.thumbnailURLString)
        }
        return URL(string: urlString)
    }
    
    var instructions: String {
        return mealDetails?.instructions ?? "Loading instructions..."
    }
    
    var ingredients: [MealDetails.Ingredient] {
        return mealDetails?.ingredients ?? []
    }
    
    func fetchDetails() {
        let urlString = baseURL + mealSummary.id
        
        networkService.request(urlString: urlString) { [weak self] (result: Result<MealDetailsResponse, NetworkError>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if let details = response.meals.first {
                    self.mealDetails = details
                    self.onDetailsUpdated?()
                } else {
                    self.onFetchError?("Meal details could not be found.")
                }
            case .failure(let error):
                self.onFetchError?(error.localizedDescription)
            }
        }
    }
}
