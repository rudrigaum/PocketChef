//
//  SearchViewModelTests.swift
//  PocketChefTests
//
//  Created by Rodrigo Cerqueira Reis on 30/09/25.
//

import Foundation
import XCTest
import Combine
@testable import PocketChef

@MainActor
final class SearchViewModelTests: XCTestCase {

    // MARK: - Properties
    private var sut: SearchViewModel!
    private var mockNetworkService: MockNetworkService!
    private var cancellables: Set<AnyCancellable>!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        sut = SearchViewModel(networkService: mockNetworkService)
        cancellables = []
    }

    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        cancellables = nil
        super.tearDown()
    }

    // MARK: - Test Cases
    func testSearch_WhenRequestSucceeds_ShouldPublishResults() async {
        let mockMeal = PocketChef.MealDetails(id: "52771", name: "Arrabiata", instructions: "", thumbnailURLString: nil, ingredients: [])
        let mockResponse = MealDetailsResponse(meals: [mockMeal])
        mockNetworkService.mockResult = .success(mockResponse)
        
        let expectation = self.expectation(description: "Publishes search results")
        var receivedResults: [PocketChef.MealDetails] = []
        
        sut.searchResultsPublisher
            .sink { results in
                receivedResults = results
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.search(for: "Arrabiata")
        await fulfillment(of: [expectation], timeout: 2.0)
        
        XCTAssertEqual(receivedResults.count, 1)
        XCTAssertEqual(receivedResults.first?.name, "Arrabiata")
    }
    
    func testSearch_WhenQueryChangesRapidly_ShouldCallNetworkOnlyOnce() async {
        let mockMeal = PocketChef.MealDetails(id: "52771", name: "Arrabiata", instructions: "", thumbnailURLString: nil, ingredients: [])
        let mockResponse = MealDetailsResponse(meals: [mockMeal])
        mockNetworkService.mockResult = .success(mockResponse)
        
        let expectation = self.expectation(description: "The final search query should publish results")
        
        sut.searchResultsPublisher
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.search(for: "a")
        sut.search(for: "ar")
        sut.search(for: "arr")
        
        await fulfillment(of: [expectation], timeout: 2.0)
        XCTAssertEqual(mockNetworkService.requestCallCount, 1, "Network service should only be called once due to debouncing.")
    }
}
