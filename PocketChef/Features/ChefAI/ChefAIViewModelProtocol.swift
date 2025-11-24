//
//  ChefAIViewModelProtocol.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 18/11/25.
//

import Foundation
import Combine

// MARK: - Message Model
public struct ChatMessage: Identifiable, Equatable {
    public let id = UUID()
    public let content: String
    public let isFromUser: Bool
    public let timestamp = Date()
}

// MARK: - State & Protocol
public enum ChefAIState: LoadingStateful {
    case idle
    case loading
    case loaded
    case error(Error)
    
    public var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
}

public protocol ChefAIViewModelProtocol: ObservableObject {
    var state: ChefAIState { get }
    var messages: [ChatMessage] { get }
    var messagesPublisher: AnyPublisher<[ChatMessage], Never> { get }
    var currentInput: String { get set }
    func sendMessage() async
    func loadInitialMessages()
}
