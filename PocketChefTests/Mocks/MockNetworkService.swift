//
//  MockNetworkService.swift
//  PocketChefTests
//
//  Created by Rodrigo Cerqueira Reis on 30/09/25.
//

import Foundation
@testable import PocketChef

final class MockNetworkService: NetworkServiceProtocol {
    
    var mockResult: Result<Any, NetworkError>?

    func request<T: Decodable>(urlString: String) async throws -> T {
        guard let result = mockResult else {
            fatalError("MockNetworkService is not configured. Set the 'mockResult' property before calling 'request'.")
        }
        
        switch result {
        case .success(let value):
            if let typedValue = value as? T {
                return typedValue
            } else {
                fatalError("Mock result type mismatch. Expected \(T.self), but got \(type(of: value)).")
            }
            
        case .failure(let error):
            throw error
        }
    }
}
