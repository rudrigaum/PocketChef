//
//  Meal.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 20/09/25.
//

import Foundation

struct MealsResponse: Decodable {
    let meals: [Meal]
}

struct Meal: Decodable, Hashable {
    let id: String
    let name: String
    let thumbnailURLString: String

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case thumbnailURLString = "strMealThumb"
    }
}
