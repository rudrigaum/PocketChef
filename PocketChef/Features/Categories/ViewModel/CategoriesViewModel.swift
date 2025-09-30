//
//  CategoriesViewModel.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 17/09/25.
//

import Foundation
import Combine

final class CategoriesViewModel: CategoriesViewModelProtocol {
    
    // MARK: - Private Properties
    private let categoriesSubject = PassthroughSubject<[PocketChef.Category], Never>()
    private let errorSubject = PassthroughSubject<String, Never>()
    
    private var categories: [PocketChef.Category] = []
    private let networkService: NetworkServiceProtocol
    private let categoriesURL = "https://www.themealdb.com/api/json/v1/1/categories.php"
    
    // MARK: - Public Publishers (Data Binding)
    var categoriesPublisher: AnyPublisher<[PocketChef.Category], Never> {
        categoriesSubject.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<String, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Initialization
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Data Source
    var numberOfCategories: Int {
        return categories.count
    }
    
    func category(at index: Int) -> PocketChef.Category? {
        guard index >= 0 && index < categories.count else {
            return nil
        }
        return categories[index]
    }
    
    // MARK: - View Actions
    func fetchCategories() async {
        do {
            let response: CategoriesResponse = try await networkService.request(urlString: categoriesURL)
            self.categories = response.categories
            
            categoriesSubject.send(self.categories)
            
        } catch {
            errorSubject.send(error.localizedDescription)
        }
    }
}
