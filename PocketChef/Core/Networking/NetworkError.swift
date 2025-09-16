//
//  NetworkError.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 16/09/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingFailed(Error)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The provided URL is invalid."
        case .requestFailed(let error):
            return "The request failed. Original error: \(error.localizedDescription)"
        case .invalidResponse:
            return "The server response was invalid (not an HTTP response)."
        case .serverError(let statusCode):
            return "The server returned an error with status: \(statusCode)."
        case .decodingFailed(let error):
            return "Failed to decode the JSON response. Error: \(error.localizedDescription)"
        }
    }
}
