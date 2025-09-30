//
//  ViewModel.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 24/09/25.
//

import Foundation
import Combine

@MainActor
final class SearchViewModel: SearchViewModelProtocol {
    
    // MARK: - Publishers (Data Binding)
    var searchResultsPublisher: AnyPublisher<[PocketChef.MealDetails], Never> {
        searchResultsSubject.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<String, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Private Properties
    private let searchResultsSubject = PassthroughSubject<[PocketChef.MealDetails], Never>()
    private let errorSubject = PassthroughSubject<String, Never>()
    
    private var searchResults: [PocketChef.MealDetails] = []
    private let networkService: NetworkServiceProtocol
    private let baseURL = "https://www.themealdb.com/api/json/v1/1/search.php?s="
    private var searchTask: Task<Void, Never>?

    // MARK: - Initialization
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Data Source
    var numberOfResults: Int {
        return searchResults.count
    }
    
    func result(at index: Int) -> PocketChef.MealDetails? {
        guard index >= 0 && index < searchResults.count else { return nil }
        return searchResults[index]
    }
    
    // MARK: - View Actions
    func search(for query: String) {
        searchTask?.cancel()
        
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            self.searchResults = []
            self.searchResultsSubject.send(self.searchResults)
            return
        }

        searchTask = Task {
            do {
                try await Task.sleep(nanoseconds: 500_000_000)
            
                let response: MealDetailsResponse = try await networkService.request(urlString: baseURL + query)
                self.searchResults = (response.meals ?? []).sorted { $0.name < $1.name }
                self.searchResultsSubject.send(self.searchResults)
                
            } catch is CancellationError {
                return
            } catch {
                if let networkError = error as? NetworkError, case .decodingFailed = networkError {
                    self.searchResults = []
                    self.searchResultsSubject.send(self.searchResults)
                } else {
                    self.errorSubject.send(error.localizedDescription)
                }
            }
        }
    }
}
