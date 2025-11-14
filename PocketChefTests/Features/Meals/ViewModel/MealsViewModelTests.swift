//
//  MealsViewModelTests.swift
//  PocketChefTests
//
//  Created by Rodrigo Cerqueira Reis on 30/09/25.
//

import Foundation
// Em: PocketChefTests/Features/Meals/ViewModel/MealsViewModelTests.swift

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
        mockCategory = Category(id: "1", name: "Beef", thumbnailURL: "", description: "")
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
    func testFetchMeals_WhenRequestSucceeds_ShouldPublishLoadedState() async {
        let mockMeal = Meal(id: "123", name: "Beef and Mustard Pie", thumbnailURLString: "")
        let mockResponse = MealsResponse(meals: [mockMeal])
        mockNetworkService.mockResult = .success(mockResponse)
        
        let expectation = self.expectation(description: "Publishes a .loaded state")
        var receivedState: MealsState?
        
        sut.statePublisher
            .dropFirst()
            .sink { state in
                receivedState = state
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await sut.fetchMeals()
        await fulfillment(of: [expectation], timeout: 1.0)
        
        guard case .loaded(let meals) = receivedState else {
            XCTFail("Expected .loaded state, but got \(String(describing: receivedState))")
            return
        }
        
        XCTAssertEqual(meals.count, 1)
        XCTAssertEqual(meals.first?.name, "Beef and Mustard Pie")
    }
    
    func testFetchMeals_WhenRequestFails_ShouldPublishErrorState() async {
        let mockError = NetworkError.serverError(statusCode: 500)
        mockNetworkService.mockResult = .failure(mockError)
        
        let expectation = self.expectation(description: "Publishes an .error state")
        var receivedState: MealsState?
    
        sut.statePublisher
            .dropFirst()
            .sink { state in
                receivedState = state
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await sut.fetchMeals()
        await fulfillment(of: [expectation], timeout: 1.0)

        guard case .error(let error) = receivedState else {
            XCTFail("Expected .error state, but got \(String(describing: receivedState))")
            return
        }
        
        XCTAssertEqual(error.localizedDescription, mockError.localizedDescription)
    }
}
