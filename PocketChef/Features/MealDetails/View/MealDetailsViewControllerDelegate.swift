//
//  MealDetailsViewControllerDelegate.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 10/10/25.
//

import Foundation

@MainActor
protocol MealDetailsViewControllerDelegate: AnyObject {
    func mealDetailsViewController(_ controller: MealDetailsViewController, didFailWith error: Error)
}
