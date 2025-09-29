//
//  MealsViewModelTests.swift
//  PocketChefTests
//
//  Created by Rodrigo Cerqueira Reis on 29/09/25.
//

import Foundation
import XCTest
@testable import PocketChef

final class MealsViewModelTests: XCTestCase {

    private var sut: MealsViewModel!
    private var mockNetworkService: MockNetworkService!
    private var mockCategory: PocketChef.Category!

    override func setUp() {
        super.setUp()
        mockCategory = PocketChef.Category(id: "1", name: "Beef", thumbnailURL: "", description: "") 
        mockNetworkService = MockNetworkService()
        sut = MealsViewModel(category: mockCategory, networkService: mockNetworkService)
    }

    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        mockCategory = nil
        super.tearDown()
    }

    // MARK: - Test Cases
    
    func testFetchMeals_WhenRequestSucceeds_ShouldUpdateMealsAndTitle() {
        let mockMeal = Meal(id: "123", name: "Beef and Mustard Pie", thumbnailURLString: "")
        let mockResponse = MealsResponse(meals: [mockMeal])
        mockNetworkService.mockResult = .success(mockResponse)
        
        let expectation = self.expectation(description: "Should call onMealsUpdated")
        
        sut.onMealsUpdated = {
            expectation.fulfill()
        }
        
        sut.fetchMeals()
        
        waitForExpectations(timeout: 1.0)
        
        XCTAssertEqual(sut.numberOfMeals, 1, "Number of meals should be 1 after a successful fetch.")
        XCTAssertEqual(sut.meal(at: 0)?.name, "Beef and Mustard Pie", "The meal name should be correct.")
        XCTAssertEqual(sut.screenTitle, "Beef Meals", "The screen title should be correctly formatted.")
    }
    
    func testFetchMeals_WhenRequestFails_ShouldTriggerError() {
        let mockError = NetworkError.serverError(statusCode: 500)
        mockNetworkService.mockResult = .failure(mockError)
        
        let expectation = self.expectation(description: "Should call onFetchError")
        var receivedErrorMessage: String?
        
        sut.onFetchError = { error in
            receivedErrorMessage = error
            expectation.fulfill()
        }
        
        sut.fetchMeals()
    
        waitForExpectations(timeout: 1.0)
        
        XCTAssertEqual(sut.numberOfMeals, 0, "Number of meals should remain 0 after a failed fetch.")
        XCTAssertNotNil(receivedErrorMessage, "An error message should have been received.")
    }
}
