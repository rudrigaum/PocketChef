//
//  ChefAIViewModelTests.swift
//  PocketChefTests
//
//  Created by Rodrigo Cerqueira Reis on 28/11/25.
//

import Foundation
import XCTest
import Combine
@testable import PocketChef

@MainActor
final class ChefAIViewModelTests: XCTestCase {
    
    private var sut: ChefAIViewModel!
    private var mockService: MockGeminiService!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockService = MockGeminiService()
        sut = ChefAIViewModel(geminiService: mockService)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testSendMessage_WhenServiceSucceeds_ShouldUpdateMessagesAndState() async {
        let prompt = "Give me a recipe"
        let expectedResponse = "Here is a recipe for pasta."
        mockService.result = .success(expectedResponse)
        
        sut.currentInput = prompt
    
        await sut.sendMessage()
        
        XCTAssertEqual(sut.messages.count, 2, "Should have 2 messages (User + AI)")
        XCTAssertEqual(sut.messages.first?.content, prompt)
        XCTAssertTrue(sut.messages.first!.isFromUser)
        
        XCTAssertEqual(sut.messages.last?.content, expectedResponse)
        XCTAssertFalse(sut.messages.last!.isFromUser)
        
        XCTAssertFalse(sut.state.isLoading)
        if case .loaded = sut.state {
        } else {
            XCTFail("State should be .loaded")
        }
        
        XCTAssertTrue(sut.currentInput.isEmpty)
    }
    
    func testSendMessage_WhenServiceFails_ShouldShowErrorMessage() async {
        let error = GeminiError.apiFailure(reason: "Server error")
        mockService.result = .failure(error)
        
        sut.currentInput = "Help me"
        
        await sut.sendMessage()
        
        XCTAssertEqual(sut.messages.count, 2)
        
        if case .error = sut.state {
        } else {
            XCTFail("State should be .error")
        }
        
        let lastMessage = sut.messages.last?.content ?? ""
        XCTAssertTrue(lastMessage.contains("Sorry"), "Should show apology message")
    }
    
    func testSendMessage_WithEmptyInput_ShouldNotCallService() async {
        sut.currentInput = "   "
        
        await sut.sendMessage()
        
        XCTAssertEqual(sut.messages.count, 0)
        XCTAssertEqual(mockService.generateContentCallCount, 0, "Service should not be called")
    }
    
    func testLoadInitialMessages_ShouldAddWelcomeMessage() {
        sut.loadInitialMessages()
        
        XCTAssertEqual(sut.messages.count, 1)
        XCTAssertTrue(sut.messages.first!.content.contains("Hello!"))
        XCTAssertFalse(sut.messages.first!.isFromUser)
    }
}
