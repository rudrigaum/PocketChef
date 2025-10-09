//
//  FavoritesViewModelProtocol.swift
//  PocketChefTests
//
//  Created by Rodrigo Cerqueira Reis on 09/10/25.
//

import Foundation
import Combine

enum FavoritesState {
    case loading
    case loaded([FavoriteMealInfo])
    case error(String)
}

@MainActor
protocol FavoritesViewModelProtocol {
    var statePublisher: AnyPublisher<FavoritesState, Never> { get }
    
    func fetchFavorites() async
}
