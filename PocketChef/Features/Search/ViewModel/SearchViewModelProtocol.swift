//
//  SearchViewModelProtocol.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 24/09/25.
//

import Foundation

protocol SearchViewModelProtocol: AnyObject {
    
    var onSearchResultsUpdated: (() -> Void)? { get set }
    var onFetchError: ((String) -> Void)? { get set }
    var numberOfResults: Int { get }
    
    func result(at index: Int) -> MealDetails?
    func search(for query: String)
}
