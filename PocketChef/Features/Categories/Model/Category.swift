//
//  Category.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 16/09/25.
//

import Foundation

struct CategoriesResponse: Decodable {
    let categories: [Category]
}

struct Category: Decodable {
    let id: String
    let name: String
    let thumbnailURL: String
    let description: String

    enum CodingKeys: String, CodingKey {
        case id = "idCategory"
        case name = "strCategory"
        case thumbnailURL = "strCategoryThumb"
        case description = "strCategoryDescription"
    }
}
