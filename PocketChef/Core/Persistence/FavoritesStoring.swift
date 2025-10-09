//
//  FavoritesStoring.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 08/10/25.
//

import Foundation

struct FavoriteMealInfo: Identifiable, Sendable, Hashable {
    let id: String
    let name: String
    let thumbnailURLString: String?
    let dateAdded: Date
}

enum FavoritesStoreError: Error, LocalizedError {
    case fetchFailed(Error)
    case saveFailed(Error)
    case deleteFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .fetchFailed(let error):
            return "Failed to fetch favorites: \(error.localizedDescription)"
        case .saveFailed(let error):
            return "Failed to save favorite: \(error.localizedDescription)"
        case .deleteFailed(let error):
            return "Failed to delete favorite: \(error.localizedDescription)"
        }
    }
}

protocol FavoritesStoring {
    func isFavorite(mealId: String) async -> Bool
    func toggleFavorite(for meal: MealDetails) async throws
    func fetchFavorites() async throws -> [FavoriteMealInfo]
}
