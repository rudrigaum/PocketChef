//
//  FavoritesFlowUITests.swift
//  PocketChefUITests
//
//  Created by Rodrigo Cerqueira Reis on 30/11/25.
//

import Foundation
import XCTest

final class FavoritesFlowUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testFavoritesFlow_AddAndRemoveFavorite_ShouldUpdateList() {
        let searchTab = app.tabBars.buttons["search_tab"]
        XCTAssertTrue(searchTab.exists)
        searchTab.tap()
        
        let searchBarContainer = app.otherElements["search_screen_search_bar"]
        let searchField = searchBarContainer.searchFields.firstMatch
        
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        searchField.tap()
        
        if app.keyboards.element.waitForExistence(timeout: 5) {
            searchField.typeText("Arrabiata")
        } else {
            searchField.typeText("Arrabiata")
        }
        
        let resultCell = app.tables["search_results_table"].cells.staticTexts["Spicy Arrabiata Penne"]
        XCTAssertTrue(resultCell.waitForExistence(timeout: 10))
        resultCell.tap()
        
        let favoriteButton = app.navigationBars.buttons["Add to favorites"]
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 5))
        
        favoriteButton.tap()
        let removeFavoriteButton = app.navigationBars.buttons["Remove from favorites"]
        XCTAssertTrue(removeFavoriteButton.exists)
        
        let favoritesTab = app.tabBars.buttons["favorites_tab"]
        favoritesTab.tap()
        
        let favoriteCell = app.tables.cells.staticTexts["Spicy Arrabiata Penne"]
        XCTAssertTrue(favoriteCell.waitForExistence(timeout: 2), "The favorited meal should appear in the list.")
        
        favoriteCell.tap()
        
        XCTAssertTrue(removeFavoriteButton.exists)
        removeFavoriteButton.tap()
        
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        let favoriteCellAfterRemove = app.tables.cells.staticTexts["Spicy Arrabiata Penne"]
        XCTAssertFalse(favoriteCellAfterRemove.exists, "A receita removida não deveria mais estar na lista.")
    }
}
