//
//  MealsViewModelProtocol.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 20/09/25.
//

import Foundation
import Combine

@MainActor
protocol MealsViewModelProtocol: AnyObject {
    
    // MARK: - Publishers for Data Binding
    var mealsPublisher: AnyPublisher<[Meal], Never> { get }
    var errorPublisher: AnyPublisher<String, Never> { get }
    
    // MARK: - Data Source
    var screenTitle: String { get }
    var numberOfMeals: Int { get }
    func meal(at index: Int) -> Meal?
    
    // MARK: - View Actions
    func fetchMeals() async
}
