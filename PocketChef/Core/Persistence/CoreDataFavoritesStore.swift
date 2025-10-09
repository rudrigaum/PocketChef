//
//  CoreDataFavoritesStore.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 08/10/25.
//

import Foundation
import CoreData

actor CoreDataFavoritesStore: FavoritesStoring {
    
    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    
    // MARK: - Initialization
    init(persistenceController: PersistenceController = .shared) {
        self.context = persistenceController.viewContext
    }
    
    // MARK: - FavoritesStoring Conformance
    func isFavorite(mealId: String) async -> Bool {
        await context.perform {
            let request = FavoriteMeal.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", mealId)
            request.fetchLimit = 1
            
            do {
                let count = try self.context.count(for: request)
                return count > 0
            } catch {
                return false
            }
        }
    }
    
    func toggleFavorite(for meal: MealDetails) async throws {
        try await context.perform {
            let request = FavoriteMeal.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", meal.id)
            request.fetchLimit = 1
            
            do {
                let existingFavorites = try self.context.fetch(request)
                
                if let existingFavorite = existingFavorites.first {
                    self.context.delete(existingFavorite)
                } else {
                    let newFavorite = FavoriteMeal(context: self.context)
                    newFavorite.id = meal.id
                    newFavorite.name = meal.name
                    newFavorite.thumbnailURLString = meal.thumbnailURLString
                    newFavorite.dateAdded = Date()
                }
                
                try self.context.save()
                
            } catch {
                throw FavoritesStoreError.saveFailed(error)
            }
        }
    }
    
    func fetchFavorites() async throws -> [FavoriteMealInfo] {
        try await context.perform {
            let request = FavoriteMeal.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \FavoriteMeal.dateAdded, ascending: false)]
            
            do {
                let favoriteMeals = try self.context.fetch(request)
                
                return favoriteMeals.map { favoriteMeal in
                    return FavoriteMealInfo(
                        id: favoriteMeal.id ?? "",
                        name: favoriteMeal.name ?? "",
                        thumbnailURLString: favoriteMeal.thumbnailURLString,
                        dateAdded: favoriteMeal.dateAdded ?? Date()
                    )
                }
            } catch {
                throw FavoritesStoreError.fetchFailed(error)
            }
        }
    }
}
