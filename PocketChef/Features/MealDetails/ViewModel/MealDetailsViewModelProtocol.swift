//
//  MealDetailsViewModelProtocol.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 22/09/25.
//

import Foundation

protocol MealDetailsViewModelProtocol: AnyObject {
    var onDetailsUpdated: (() -> Void)? { get set }
    var onFetchError: ((String) -> Void)? { get set }
    var mealName: String { get }
    var mealThumbnailURL: URL? { get }
    var instructions: String { get }
    var ingredients: [MealDetails.Ingredient] { get }
    
    func fetchDetails()
}
