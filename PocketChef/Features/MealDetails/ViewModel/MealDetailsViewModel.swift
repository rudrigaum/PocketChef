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
    
    var isFavoritePublisher: AnyPublisher<Bool, Never> {
        isFavoriteSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Private Properties
    private let detailsSubject = PassthroughSubject<MealDetails, Never>()
    private let errorSubject = PassthroughSubject<String, Never>()
    private let isFavoriteSubject = CurrentValueSubject<Bool, Never>(false)
    private let mealSummary: Meal
    private var mealDetails: MealDetails?
    private let networkService: NetworkServiceProtocol
    private let favoritesStore: FavoritesStoring
    private let baseURL = "https://www.themealdb.com/api/json/v1/1/lookup.php?i="

    // MARK: - Initialization
    init(meal: Meal,
         networkService: NetworkServiceProtocol = NetworkService(),
         favoritesStore: FavoritesStoring = CoreDataFavoritesStore()) {
        self.mealSummary = meal
        self.networkService = networkService
        self.favoritesStore = favoritesStore
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
        await checkInitialFavoriteStatus()
        
        do {
            let response: MealDetailsResponse = try await networkService.request(urlString: baseURL + mealSummary.id)
            
            if let details = response.meals?.first {
                self.mealDetails = details
                detailsSubject.send(details)
            } else {
                throw NetworkError.invalidResponse
            }
        } catch {
            errorSubject.send(error.localizedDescription)
        }
    }
    
    func toggleFavoriteStatus() async {
        guard let details = mealDetails else { return }
        do {
            try await favoritesStore.toggleFavorite(for: details)
            let isFavorite = await favoritesStore.isFavorite(mealId: details.id)
            isFavoriteSubject.send(isFavorite)
        } catch {
            errorSubject.send(error.localizedDescription)
        }
    }
    
    // MARK: - Private Methods
    private func checkInitialFavoriteStatus() async {
        let isFavorite = await favoritesStore.isFavorite(mealId: mealSummary.id)
        isFavoriteSubject.send(isFavorite)
    }
}
