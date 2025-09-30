//
//  SearchViewModelProtocol.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 24/09/25.
//

import Foundation
import Combine

protocol SearchViewModelProtocol: AnyObject {
    
    // MARK: - Publishers for Data Binding
    var searchResultsPublisher: AnyPublisher<[PocketChef.MealDetails], Never> { get }
    var errorPublisher: AnyPublisher<String, Never> { get }
    
    // MARK: - Data Source
    var numberOfResults: Int { get }
    func result(at index: Int) -> PocketChef.MealDetails?
    
    // MARK: - View Actions
    func search(for query: String) async
}
