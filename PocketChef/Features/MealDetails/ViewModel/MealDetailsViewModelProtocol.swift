//
//  MealDetailsViewModelProtocol.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 22/09/25.
//

import Foundation
import Combine

protocol MealDetailsViewModelProtocol: AnyObject {
    
    // MARK: - Publishers for Data Binding
    var detailsPublisher: AnyPublisher<MealDetails, Never> { get }
    var errorPublisher: AnyPublisher<String, Never> { get }
    
    // MARK: - Data Source
    var mealName: String { get }
    var mealThumbnailURL: URL? { get }
    
    // MARK: - View Actions
    func fetchDetails() async
}
