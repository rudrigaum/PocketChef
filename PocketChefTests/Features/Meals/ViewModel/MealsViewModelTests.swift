//
//  MealsViewModelTests.swift
//  PocketChefTests
//
//  Created by Rodrigo Cerqueira Reis on 30/09/25.
//

import Foundation
import XCTest
import Combine
@testable import PocketChef

@MainActor
final class MealsViewModelTests: XCTestCase {

    // MARK: - Properties
    private var sut: MealsViewModel!
    private var mockNetworkService: MockNetworkService!
    private var mockCategory: PocketChef.Category!
    private var cancellables: Set<AnyCancellable>!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        mockCategory = PocketChef.Category(id: "1", name: "Beef", thumbnailURL: "", description: "")
        mockNetworkService = MockNetworkService()
        sut = MealsViewModel(category: mockCategory, networkService: mockNetworkService)
        cancellables = []
    }

    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        mockCategory = nil
        cancellables = nil
        super.tearDown()
    }

    // MARK: - Test Cases
    func testFetchMeals_WhenRequestSucceeds_ShouldPublishMeals() async {
        let mockMeal = Meal(id: "52874", name: "Beef and Mustard Pie", thumbnailURLString: "")
        let mockResponse = MealsResponse(meals: [mockMeal])
        mockNetworkService.mockResult = .success(mockResponse)
        
        let expectation = self.expectation(description: "Publishes an array of meals")
        var receivedMeals: [Meal] = []
        
        sut.mealsPublisher
            .sink { meals in
                receivedMeals = meals
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await sut.fetchMeals()
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertEqual(receivedMeals.count, 1)
        XCTAssertEqual(sut.numberOfMeals, 1, "Number of meals should be 1 after a successful fetch.")
        XCTAssertEqual(sut.meal(at: 0)?.name, "Beef and Mustard Pie", "The meal name should be correct.")
        XCTAssertEqual(sut.screenTitle, "Beef Meals", "The screen title should be correctly formatted based on the mock category.")
    }

    func testFetchMeals_WhenRequestFails_ShouldPublishError() async {
        let mockError = NetworkError.serverError(statusCode: 500)
        mockNetworkService.mockResult = .failure(mockError)
        
        let expectation = self.expectation(description: "Publishes an error object")
        var receivedError: Error?

        sut.errorPublisher
            .sink { error in
                receivedError = error
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await sut.fetchMeals()
        await fulfillment(of: [expectation], timeout: 1.0)

        XCTAssertNotNil(receivedError, "Should receive an error object.")
        XCTAssertEqual(sut.numberOfMeals, 0, "Number of meals should be 0 after a failed fetch.")
    }
}
