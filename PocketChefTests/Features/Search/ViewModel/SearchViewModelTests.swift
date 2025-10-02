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
    private var mockHistoryStore: MockSearchHistoryStore!
    private var cancellables: Set<AnyCancellable>!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockHistoryStore = MockSearchHistoryStore()
        sut = SearchViewModel(
            networkService: mockNetworkService,
            searchHistoryStore: mockHistoryStore
        )
        cancellables = []
    }

    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        mockHistoryStore = nil
        cancellables = nil
        super.tearDown()
    }

    // MARK: - Test Cases
    func testLoadInitialState_WhenHistoryExists_ShouldPublishShowingHistoryState() {
        
        let history = ["chicken", "beef"]
        mockHistoryStore.mockHistory = history
        let expectation = self.expectation(description: "Publishes .showingHistory state")
        var receivedState: SearchState?
        
        sut.statePublisher
            .dropFirst()
            .sink { state in
                receivedState = state
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.loadInitialState()
        
        waitForExpectations(timeout: 1.0)
        
        guard case .showingHistory(let receivedHistory) = receivedState else {
            XCTFail("Expected .showingHistory state, but got \(String(describing: receivedState))")
            return
        }
        XCTAssertEqual(receivedHistory, history)
    }
    
    func testSearch_WhenRequestSucceeds_ShouldSaveTermAndPublishResults() {
        let query = "Arrabiata"
        let mockMeal = PocketChef.MealDetails(id: "52771", name: query, instructions: "", thumbnailURLString: nil, ingredients: [])
        let mockResponse = MealDetailsResponse(meals: [mockMeal])
        mockNetworkService.mockResult = .success(mockResponse)
        
        let expectation = self.expectation(description: "Publishes .showingResults state")
        var finalState: SearchState?
        
        sut.statePublisher
            .dropFirst()
            .sink { state in
                if case .showingResults = state {
                    finalState = state
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.search(for: query)
        
        waitForExpectations(timeout: 2.0)
        
        guard case .showingResults(let results) = finalState else {
            XCTFail("Expected .showingResults, but got \(String(describing: finalState))")
            return
        }
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.name, query)
        XCTAssertTrue(mockHistoryStore.mockHistory.contains(query))
    }
}
