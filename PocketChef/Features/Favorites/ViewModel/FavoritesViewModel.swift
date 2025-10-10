//
//  FavoritesViewModel.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 09/10/25.
//

import Foundation
import Combine

@MainActor
final class FavoritesViewModel: FavoritesViewModelProtocol {
    
    // MARK: - Publishers
    var statePublisher: AnyPublisher<FavoritesState, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Private Properties
    private let stateSubject = CurrentValueSubject<FavoritesState, Never>(.loading)
    private let favoritesStore: FavoritesStoring

    // MARK: - Initialization
    init(favoritesStore: FavoritesStoring = CoreDataFavoritesStore()) {
        self.favoritesStore = favoritesStore
    }
    
    // MARK: - View Actions
    func fetchFavorites() async {
        stateSubject.send(.loading)
        
        do {
            let favorites = try await favoritesStore.fetchFavorites()
            stateSubject.send(.loaded(favorites))
        } catch {
            stateSubject.send(.error(error.localizedDescription))
        }
    }
}
