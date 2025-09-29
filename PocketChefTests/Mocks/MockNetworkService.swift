//
//  MockNetworkService.swift
//  PocketChefTests
//
//  Created by Rodrigo Cerqueira Reis on 25/09/25.
//

import Foundation
@testable import PocketChef

final class MockNetworkService: NetworkServiceProtocol {
    
    var mockResult: Result<Any, NetworkError>?
    
    func request<T: Decodable>(urlString: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let result = mockResult else {
            fatalError("MockNetworkService is not configured. Set the 'mockResult' property before calling 'request'.")
        }
        
        switch result {
        case .success(let value):
            if let typedValue = value as? T {
                completion(.success(typedValue))
            } else {
                fatalError("Mock result type mismatch. Expected \(T.self), but got \(type(of: value)).")
            }
            
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
