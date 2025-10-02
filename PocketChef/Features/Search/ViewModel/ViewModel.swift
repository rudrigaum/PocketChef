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
    var statePublisher: AnyPublisher<SearchState, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Private Properties
    private let stateSubject = CurrentValueSubject<SearchState, Never>(.idle)
    
    private let networkService: NetworkServiceProtocol
    private let searchHistoryStore: SearchHistoryStore
    
    private let baseURL = "https://www.themealdb.com/api/json/v1/1/search.php?s="
    private var searchTask: Task<Void, Never>?

    // MARK: - Initialization
    init(networkService: NetworkServiceProtocol = NetworkService(),
         searchHistoryStore: SearchHistoryStore = UserDefaultsSearchHistoryStore()) {
        self.networkService = networkService
        self.searchHistoryStore = searchHistoryStore
    }
    
    // MARK: - View Actions
    func loadInitialState() {
        let history = searchHistoryStore.getSearchHistory()
        stateSubject.send(.showingHistory(history))
    }
    
    func search(for query: String) {
        searchTask?.cancel()
        
        let trimmedQuery = query.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedQuery.isEmpty else {
            loadInitialState()
            return
        }
        
        stateSubject.send(.loading)
        
        searchTask = Task {
            do {
                try await Task.sleep(nanoseconds: 500_000_000)
                
                let response: MealDetailsResponse = try await networkService.request(urlString: baseURL + trimmedQuery)
                let results = response.meals ?? []
                
                searchHistoryStore.save(searchTerm: trimmedQuery)
                stateSubject.send(.showingResults(results))
                
            } catch is CancellationError {
                return
            } catch {
                stateSubject.send(.error(error.localizedDescription))
            }
        }
    }
}
