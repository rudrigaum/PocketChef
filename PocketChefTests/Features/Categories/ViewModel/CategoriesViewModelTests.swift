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

@MainActor
final class CategoriesViewModelTests: XCTestCase {

    private var sut: CategoriesViewModel!
    private var mockNetworkService: MockNetworkService!
    private var cancellables: Set<AnyCancellable>!

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

    func testFetchCategories_WhenRequestSucceeds_ShouldPublishLoadedState() async {
        let mockCategory = Category(id: "1", name: "Dessert", thumbnailURL: "", description: "")
        let mockResponse = CategoriesResponse(categories: [mockCategory])
        mockNetworkService.mockResult = .success(mockResponse)
        
        let expectation = self.expectation(description: "Publishes a .loaded state")
        var receivedState: CategoriesState?
        
        sut.statePublisher
            .first(where: { $0.isNotLoading })
            .sink { state in
                receivedState = state
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await sut.fetchCategories()
        
        await fulfillment(of: [expectation], timeout: 1.0)
        
        guard case .loaded(let categories) = receivedState else {
            XCTFail("Expected .loaded state, but got \(String(describing: receivedState))")
            return
        }
        
        XCTAssertEqual(categories.count, 1)
        XCTAssertEqual(categories.first?.name, "Dessert")
    }
    
    func testFetchCategories_WhenRequestFails_ShouldPublishErrorState() async {
        let mockError = NetworkError.invalidResponse
        mockNetworkService.mockResult = .failure(mockError)
        
        let expectation = self.expectation(description: "Publishes an .error state")
        var receivedState: CategoriesState?
        
        sut.statePublisher
            .first(where: { $0.isNotLoading })
            .sink { state in
                receivedState = state
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await sut.fetchCategories()
        await fulfillment(of: [expectation], timeout: 1.0)

        guard case .error(let error) = receivedState else {
            XCTFail("Expected .error state, but got \(String(describing: receivedState))")
            return
        }
        
        XCTAssertEqual(error.localizedDescription, mockError.localizedDescription)
    }
}
