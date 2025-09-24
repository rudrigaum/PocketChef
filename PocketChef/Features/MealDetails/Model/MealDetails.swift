//
//  MealDetails.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 22/09/25.
//

import Foundation

struct MealDetailsResponse: Decodable {
    let meals: [MealDetails]
}

struct MealDetails: Decodable {
    
    struct Ingredient: Hashable {
        let name: String
        let measure: String
    }
    
    let id: String
    let name: String
    let instructions: String
    let thumbnailURLString: String?
    
    let ingredients: [Ingredient]
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case instructions = "strInstructions"
        case thumbnailURLString = "strMealThumb"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.instructions = try container.decode(String.self, forKey: .instructions)
        self.thumbnailURLString = try container.decodeIfPresent(String.self, forKey: .thumbnailURLString)
        
        var ingredientsArray: [Ingredient] = []
        
        for i in 1...20 {
            let ingredientKey = "strIngredient\(i)"
            let measureKey = "strMeasure\(i)"
            
            let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKey.self)
            
            if let ingredientName = try dynamicContainer.decodeIfPresent(String.self, forKey: DynamicCodingKey(stringValue: ingredientKey)),
               let measure = try dynamicContainer.decodeIfPresent(String.self, forKey: DynamicCodingKey(stringValue: measureKey)),
               !ingredientName.trimmingCharacters(in: .whitespaces).isEmpty {
                
                ingredientsArray.append(.init(name: ingredientName, measure: measure))
            }
        }
        
        self.ingredients = ingredientsArray
    }
    
    private struct DynamicCodingKey: CodingKey {
        var stringValue: String
        init(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }
    }
}
