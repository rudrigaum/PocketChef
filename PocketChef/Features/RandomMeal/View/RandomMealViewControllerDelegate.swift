//
//  RandomMealViewControllerDelegate.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 27/10/25.
//

import Foundation

@MainActor
protocol RandomMealViewControllerDelegate: AnyObject {
    func randomMealViewController(_ controller: RandomMealViewController, didRequestDetailsFor meal: MealDetails)
    func randomMealViewController(_ controller: RandomMealViewController, didFailWith error: Error)
}
