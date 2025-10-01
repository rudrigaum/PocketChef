//
//  CategoriesViewModelTests.swift
//  PocketChefTests
//
//  Created by Rodrigo Cerqueira Reis on 30/09/25.
//

import Foundation
import XCTest
import Combine
@testable import PocketChef

final class CategoriesViewModelTests: XCTestCase {

    // MARK: - Properties
    private var sut: CategoriesViewModel!
    private var mockNetworkService: MockNetworkService!
    private var cancellables: Set<AnyCancellable>!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        sut = CategoriesViewModel(networkService: mockNetworkService)
        cancellables = []
    }

    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        cancellables = nil
        super.tearDown()
    }

    // MARK: - Test Cases
    func testFetchCategories_WhenRequestSucceeds_ShouldPublishCategories() async {
        let mockCategory = PocketChef.Category(id: "1", name: "Dessert", thumbnailURL: "", description: "")
        let mockResponse = CategoriesResponse(categories: [mockCategory])
        mockNetworkService.mockResult = .success(mockResponse)
        
        let expectation = self.expectation(description: "Publishes an array of categories")
        var receivedCategories: [PocketChef.Category] = []
        
        sut.categoriesPublisher
            .sink { categories in
                receivedCategories = categories
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await sut.fetchCategories()
        
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertEqual(receivedCategories.count, 1, "Should receive one category.")
        XCTAssertEqual(receivedCategories.first?.name, "Dessert", "The category name should be correct.")
    }
    
    func testFetchCategories_WhenRequestFails_ShouldPublishError() async {
        let mockError = NetworkError.invalidResponse
        mockNetworkService.mockResult = .failure(mockError)
        
        let expectation = self.expectation(description: "Publishes an error message")
        var receivedError: String?

        sut.errorPublisher
            .sink { errorMessage in
                receivedError = errorMessage
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await sut.fetchCategories()
    
        await fulfillment(of: [expectation], timeout: 1.0)

        XCTAssertNotNil(receivedError, "Should receive an error message.")
        XCTAssertEqual(receivedError, mockError.localizedDescription, "The error message should match.")
    }
}
