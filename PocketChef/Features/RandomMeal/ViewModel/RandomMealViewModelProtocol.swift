//
//  RandomMealViewModelProtocol.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 26/10/25.
//

import Foundation
import Combine

enum RandomMealState {
    case idle
    case loading
    case loaded(MealDetails)
    case error(Error)
}

@MainActor
protocol RandomMealViewModelProtocol: AnyObject {
    var statePublisher: AnyPublisher<RandomMealState, Never> { get }
    func fetchRandomMeal() async
}
