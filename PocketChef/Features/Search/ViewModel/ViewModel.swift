//
//  ViewModel.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 24/09/25.
//

import Foundation

final class SearchViewModel: SearchViewModelProtocol {

    var onSearchResultsUpdated: (() -> Void)?
    var onFetchError: ((String) -> Void)?
    
    private var searchResults: [MealDetails] = []
    private let networkService: NetworkServiceProtocol
    private let baseURL = "https://www.themealdb.com/api/json/v1/1/search.php?s="
    private var searchWorkItem: DispatchWorkItem?
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    var numberOfResults: Int {
        return searchResults.count
    }
    
    func result(at index: Int) -> MealDetails? {
        guard index >= 0 && index < searchResults.count else { return nil }
        return searchResults[index]
    }
    
    func search(for query: String) {
        searchWorkItem?.cancel()
        
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            self.searchResults = []
            self.onSearchResultsUpdated?()
            return
        }

        let newSearchWorkItem = DispatchWorkItem { [weak self] in
            self?.performSearch(query: query)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: newSearchWorkItem)
        self.searchWorkItem = newSearchWorkItem
    }
    
    private func performSearch(query: String) {
        let urlString = baseURL + query
        
        networkService.request(urlString: urlString) { [weak self] (result: Result<MealDetailsResponse, NetworkError>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.searchResults = response.meals.sorted { $0.name < $1.name }
                self.onSearchResultsUpdated?()
            case .failure(let error):
                if case .decodingFailed = error {
                    self.searchResults = []
                    self.onSearchResultsUpdated?()
                } else {
                    self.onFetchError?(error.localizedDescription)
                }
            }
        }
    }
}
