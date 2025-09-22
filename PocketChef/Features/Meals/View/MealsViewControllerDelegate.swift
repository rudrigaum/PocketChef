//
//  MealsViewControllerDelegate.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 22/09/25.
//

import Foundation

protocol MealsViewControllerDelegate: AnyObject {
    func mealsViewController(_ controller: MealsViewController, didSelectMeal meal: Meal)
}
