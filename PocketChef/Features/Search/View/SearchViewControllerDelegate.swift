//
//  SearchViewControllerDelegate.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 25/09/25.
//

import Foundation

protocol SearchViewControllerDelegate: AnyObject {
    func searchViewController(_ controller: SearchViewController, didSelectMeal meal: MealDetails)
}
