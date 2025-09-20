//
//  MealsViewModelProtocol.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 20/09/25.
//

import Foundation

protocol MealsViewModelProtocol: AnyObject {
    var onMealsUpdated: (() -> Void)? { get set }
    var onFetchError: ((String) -> Void)? { get set }
    var screenTitle: String { get }
    var numberOfMeals: Int { get }
    
    func meal(at index: Int) -> Meal?
    func fetchMeals()
}
