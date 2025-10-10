//
//  FavoritesViewControllerDelegate.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 09/10/25.
//

import Foundation


@MainActor
protocol FavoritesViewControllerDelegate: AnyObject {
    func favoritesViewController(_ controller: FavoritesViewController, didSelectFavorite favorite: FavoriteMealInfo)
}
