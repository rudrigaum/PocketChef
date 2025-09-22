//
//  CategoriesViewControllerDelegate.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 20/09/25.
//

import Foundation

protocol CategoriesViewControllerDelegate: AnyObject {
    func categoriesViewController(_ controller: CategoriesViewController, didSelectCategory category: Category)
}
