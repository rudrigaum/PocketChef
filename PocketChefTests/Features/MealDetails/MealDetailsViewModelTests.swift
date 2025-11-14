//
//  MealDetailsViewModelTests.swift
//  PocketChefTests
//
//  Created by Rodrigo Cerqueira Reis on 01/10/25.
//

import Foundation
import XCTest
import Combine
@testable import PocketChef

@MainActor
final class MealDetailsViewModelTests: XCTestCase {

    // MARK: - Properties
    private var sut: MealDetailsViewModel!
    private var mockNetworkService: MockNetworkService!
    private var mockMealSummary: Meal!
    private var cancellables: Set<AnyCancellable>!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        mockMealSummary = Meal(id: "52772", name: "Teriyaki Chicken Casserole", thumbnailURLString: "")
        mockNetworkService = MockNetworkService()
        sut = MealDetailsViewModel(meal: mockMealSummary, networkService: mockNetworkService)
        cancellables = []
    }

    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        mockMealSummary = nil
        cancellables = nil
        super.tearDown()
    }

    // MARK: - Test Cases
    
    func testFetchDetails_WhenRequestSucceeds_ShouldPublishDetails() async {
        let mockDetails = MealDetails(id: "52772", name: "Teriyaki Chicken Casserole", instructions: "...", thumbnailURLString: nil, ingredients: [])
        let mockResponse = MealDetailsResponse(meals: [mockDetails])
        mockNetworkService.mockResult = .success(mockResponse)
        
        let expectation = self.expectation(description: "Publishes meal details")
        var receivedDetails: MealDetails?
        
        sut.detailsPublisher
            .sink { details in
                receivedDetails = details
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await sut.fetchDetails()
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertNotNil(receivedDetails)
        XCTAssertEqual(receivedDetails?.id, "52772")
    }
    
    func testFetchDetails_WhenRequestFails_ShouldPublishError() async {

        let mockError = NetworkError.invalidURL
        mockNetworkService.mockResult = .failure(mockError)
        
        let expectation = self.expectation(description: "Publishes an error object")
        var receivedError: Error?

        sut.errorPublisher
            .sink { error in
                receivedError = error
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await sut.fetchDetails()
        await fulfillment(of: [expectation], timeout: 1.0)

        XCTAssertNotNil(receivedError, "Should receive an error object.")
        XCTAssertEqual(receivedError?.localizedDescription, mockError.localizedDescription)
    }
}
