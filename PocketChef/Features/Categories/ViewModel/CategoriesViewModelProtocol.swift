//
//  CategoriesViewModelProtocol.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 16/09/25.
//

import Foundation
import Combine

enum CategoriesState: LoadingStateful {
    case loading
    case loaded([Category])
    case error(Error)
    
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
}

@MainActor
protocol CategoriesViewModelProtocol: AnyObject {
    // MARK: - Publishers for Data Binding
    var statePublisher: AnyPublisher<CategoriesState, Never> { get }
    
    // MARK: - View Actions
    func fetchCategories() async
}
