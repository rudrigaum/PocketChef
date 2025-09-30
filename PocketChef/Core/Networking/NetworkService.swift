//
//  NetworkService.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 16/09/25.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    
    func request<T: Decodable>(urlString: String) async throws -> T {

        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return decodedObject
            
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}
