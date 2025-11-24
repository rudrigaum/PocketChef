//
//  GeminiAPIService.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 18/11/25.
//

import Foundation
import GoogleGenerativeAI

public final class GeminiAPIService: GeminiAPIServiceProtocol {
    
    // MARK: - Properties
    private let model: GenerativeModel
    
    // MARK: - Initialization
    public init(apiKey: String) {
        self.model = GenerativeModel(
            name: "gemini-2.5-flash",
            apiKey: apiKey
        )
    }
    
    // MARK: - GeminiAPIServiceProtocol
    public func generateContent(prompt: String) async throws -> String {
        let fullPrompt = self.buildFullPrompt(from: prompt)
        
        do {
            let response = try await model.generateContent(fullPrompt)
            
            guard let text = response.text, !text.isEmpty else {
                throw GeminiError.emptyResponse
            }
            
            return text
            
        } catch let apiError as GenerateContentError {
            print("Gemini API Error: \(apiError.localizedDescription)")
            throw GeminiError.apiFailure(reason: apiError.localizedDescription)
        } catch {
            // 5. Outros erros
            throw error
        }
    }
    
    // MARK: - Private Methods
    
    private func buildFullPrompt(from userPrompt: String) -> String {
        let systemInstruction = """
                You are Chef AI, an experienced culinary assistant for an app called PocketChef.
                Your personality is friendly, encouraging, and extremely focused on food safety.
                Answer all questions concisely and always use formatted lists (markdown) for recipes or steps.
                Always start the response with a friendly greeting and conclude with a kitchen safety tip.
                """
        
        return "\(systemInstruction)\n\nUSER QUESTION: \(userPrompt)"
    }
}

// MARK: - Custom Errors
public enum GeminiError: Error, LocalizedError {
    case emptyResponse
    case apiFailure(reason: String)
    
    public var errorDescription: String? {
        switch self {
        case .emptyResponse:
            return "Chef AI could not generate a response for your request. Please try rephrasing it."
        case .apiFailure(let reason):
            return "Connection error with Chef AI: \(reason)"
        }
    }
}
