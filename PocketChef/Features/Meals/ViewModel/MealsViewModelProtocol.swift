//
//  MealsViewModelProtocol.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 20/09/25.
//

import Foundation
import Combine

enum MealsState: LoadingStateful {
    case loading
    case loaded([Meal])
    case error(Error)
    
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
}

@MainActor
protocol MealsViewModelProtocol: AnyObject {
    var statePublisher: AnyPublisher<MealsState, Never> { get }
    var screenTitle: String { get }
    func fetchMeals() async
}
