//
//  CategoriesViewControllerDelegate.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 20/09/25.
//

import Foundation

@MainActor
protocol CategoriesViewControllerDelegate: AnyObject {
    func categoriesViewController(_ controller: CategoriesViewController, didSelectCategory category: Category)
    func categoriesViewController(_ controller: CategoriesViewController, didFailWith error: Error) 
}
