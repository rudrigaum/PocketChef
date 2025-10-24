//
//  SearchFlowUITests.swift
//  PocketChefUITests
//
//  Created by Rodrigo Cerqueira Reis on 20/10/25.
//

import XCTest

final class SearchFlowUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }

    func testSearchFlow_WhenSearchingForChicken_ShouldNavigateToDetails() {
        let searchTab = app.tabBars.buttons["search_tab"]
        
        let searchBarContainer = app.otherElements["search_screen_search_bar"]
        let searchField = searchBarContainer.searchFields.firstMatch
        
        let resultsTable = app.tables["search_results_table"]
        let expectedResultCell = resultsTable.cells.staticTexts["Brown Stew Chicken"]
        let expectedDetailTitle = app.navigationBars["Brown Stew Chicken"]
        
        XCTAssertTrue(searchTab.exists, "A aba de Busca deve existir.")
        searchTab.tap()
        
        XCTAssertTrue(searchField.waitForExistence(timeout: 5), "O campo de busca deve existir.")
        searchField.tap()
        searchField.typeText("Chicken")
        
        XCTAssertTrue(expectedResultCell.waitForExistence(timeout: 10), "A célula 'Brown Stew Chicken' deve aparecer.")
        expectedResultCell.tap()
        XCTAssertTrue(expectedDetailTitle.waitForExistence(timeout: 2), "O título da tela de detalhes deve ser 'Brown Stew Chicken'.")
    }
}
