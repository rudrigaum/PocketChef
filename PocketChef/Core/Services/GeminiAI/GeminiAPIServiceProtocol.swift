//
//  GeminiAPIServiceProtocol.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 18/11/25.
//

import Foundation

public protocol GeminiAPIServiceProtocol {
    func generateContent(prompt: String) async throws -> String
}
