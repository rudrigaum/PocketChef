//
//  CategoriesViewModelProtocol.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 16/09/25.
//

import Foundation

protocol CategoriesViewModelProtocol: AnyObject {
    var onCategoriesUpdated: (() -> Void)? { get set }
    var onFetchError: ((String) -> Void)? { get set }
    var numberOfCategories: Int { get }
    func category(at index: Int) -> Category?
    func fetchCategories()
}
