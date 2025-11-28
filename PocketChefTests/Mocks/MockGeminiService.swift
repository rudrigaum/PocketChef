//
//  MockGeminiService.swift
//  PocketChefTests
//
//  Created by Rodrigo Cerqueira Reis on 28/11/25.
//

import Foundation

@testable import PocketChef

final class MockGeminiService: GeminiAPIServiceProtocol {
    
    var result: Result<String, Error>?
    private(set) var generateContentCallCount = 0
    
    func generateContent(prompt: String) async throws -> String {
        generateContentCallCount += 1
        
        guard let result = result else {
            fatalError("MockGeminiService: Result not configured. Please set 'result' before calling.")
        }
        
        switch result {
        case .success(let content):
            return content
        case .failure(let error):
            throw error
        }
    }
}
