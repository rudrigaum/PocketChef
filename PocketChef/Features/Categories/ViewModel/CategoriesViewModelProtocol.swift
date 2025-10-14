//
//  CategoriesViewModelProtocol.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 16/09/25.
//

import Foundation
import Combine

@MainActor
protocol CategoriesViewModelProtocol: AnyObject {
    
    // MARK: - Publishers for Data Binding

    var categoriesPublisher: AnyPublisher<[PocketChef.Category], Never> { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
    
    // MARK: - Data Source (agora derivado dos Publishers)
    
    var numberOfCategories: Int { get }
    func category(at index: Int) -> PocketChef.Category?
    
    // MARK: - View Actions
    
    func fetchCategories() async
}
