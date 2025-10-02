//
//  SearchViewModelProtocol.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 24/09/25.
//

import Foundation
import Combine

enum SearchState {
    case idle
    case loading
    case showingHistory([String])
    case showingResults([PocketChef.MealDetails])
    case error(String)
}



protocol SearchViewModelProtocol: AnyObject {
    
    // MARK: - Publishers for Data Binding
    var statePublisher: AnyPublisher<SearchState, Never> { get }
    
    // MARK: - View Actions
    func loadInitialState()
    func search(for query: String)
    func deleteHistory(term: String) 
}
