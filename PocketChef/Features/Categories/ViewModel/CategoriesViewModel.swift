//
//  CategoriesViewModel.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 17/09/25.
//

import Foundation
import Combine
import CoreData

@MainActor
final class CategoriesViewModel: CategoriesViewModelProtocol {
    
    // MARK: - Publishers
    var statePublisher: AnyPublisher<CategoriesState, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Private Properties
    private let stateSubject = CurrentValueSubject<CategoriesState, Never>(.loading)
    private let networkService: NetworkServiceProtocol
    private let categoriesURL = "https://www.themealdb.com/api/json/v1/1/categories.php"
    
    // MARK: - Initialization
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - View Actions
    func fetchCategories() async {
        stateSubject.send(.loading)
        
        do {
            let response: CategoriesResponse = try await networkService.request(urlString: categoriesURL)
            stateSubject.send(.loaded(response.categories))
            
        } catch {
            stateSubject.send(.error(error))
        }
    }
}
