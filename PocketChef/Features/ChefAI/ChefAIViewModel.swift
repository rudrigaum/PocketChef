//
//  ChefAIViewModel.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 18/11/25.
//

import Foundation
import Combine

@MainActor
public final class ChefAIViewModel: ChefAIViewModelProtocol {
    
    // MARK: - Published Properties
    @Published public private(set) var state: ChefAIState = .idle
    @Published public private(set) var messages: [ChatMessage] = []
    @Published public var currentInput: String = ""
    
    public var messagesPublisher: AnyPublisher<[ChatMessage], Never> {
        $messages.eraseToAnyPublisher()
    }
    
    // MARK: - Dependencies
    private let geminiService: GeminiAPIServiceProtocol
    
    // MARK: - Initialization
    public init(geminiService: GeminiAPIServiceProtocol) {
        self.geminiService = geminiService
    }
    
    // MARK: - Actions
    public func sendMessage() async {
        let message = currentInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !message.isEmpty else { return }
        
        let userMessage = ChatMessage(content: message, isFromUser: true)
        messages.append(userMessage)
        currentInput = ""
        
        state = .loading
        
        do {
            let aiResponseText = try await geminiService.generateContent(prompt: message)
            
            let aiMessage = ChatMessage(content: aiResponseText, isFromUser: false)
            messages.append(aiMessage)
            state = .loaded
            
        } catch {
            print("Error generating content: \(error)")
            state = .error(error)
            
            let errorMessage = ChatMessage(content: "Sorry, my friend. I had a connection error. Please try again.", isFromUser: false)
            messages.append(errorMessage)
        }
    }
    
    public func loadInitialMessages() {
        guard messages.isEmpty else { return }
        
        let welcome = ChatMessage(
            content: "Hello! I am Chef AI. Tell me what ingredients you have, and I'll suggest the perfect recipe. What are you cooking today?",
            isFromUser: false
        )
        
        self.messages.append(welcome)
    }
}
