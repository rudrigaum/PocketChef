//
//  CategoriesViewModelTests.swift
//  PocketChefTests
//
//  Created by Rodrigo Cerqueira Reis on 25/09/25.
//

import XCTest
@testable import PocketChef

final class CategoriesViewModelTests: XCTestCase {

    private var sut: CategoriesViewModel!
    private var mockNetworkService: MockNetworkService!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        sut = CategoriesViewModel(networkService: mockNetworkService)
    }

    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        super.tearDown()
    }

    func testFetchCategories_WhenRequestSucceeds_ShouldUpdateCategories() {
        let mockCategory = PocketChef.Category(id: "1", name: "Dessert", thumbnailURL: "", description: "") // << CORREÇÃO AQUI
        let mockResponse = CategoriesResponse(categories: [mockCategory])
        mockNetworkService.mockResult = .success(mockResponse)
        
        let expectation = self.expectation(description: "Should call onCategoriesUpdated")
        
        sut.onCategoriesUpdated = {
            expectation.fulfill()
        }
        
        sut.fetchCategories()
        
        waitForExpectations(timeout: 1.0)
        
        XCTAssertEqual(sut.numberOfCategories, 1)
        XCTAssertEqual(sut.category(at: 0)?.name, "Dessert")
    }
    
    func testFetchCategories_WhenRequestFails_ShouldTriggerError() {
        let mockError = NetworkError.invalidResponse
        mockNetworkService.mockResult = .failure(mockError)
        
        let expectation = self.expectation(description: "Should call onFetchError")
        var receivedError: String?
        
        sut.onFetchError = { errorMessage in
            receivedError = errorMessage
            expectation.fulfill()
        }
        
        sut.fetchCategories()
        
        waitForExpectations(timeout: 1.0)
        
        XCTAssertEqual(sut.numberOfCategories, 0, "Number of categories should be 0 after a failed fetch.")
        XCTAssertNotNil(receivedError, "An error message should have been received.")
        XCTAssertEqual(receivedError, mockError.localizedDescription, "The received error message should match the mock error.")
    }
}
