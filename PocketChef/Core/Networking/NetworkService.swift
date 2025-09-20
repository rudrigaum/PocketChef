//
//  NetworkService.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 16/09/25.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    
    func request<T: Decodable>(urlString: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            let result = self.handleResponse(data: data, response: response, error: error) as Result<T, NetworkError>
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        task.resume()
    }
    
    private func handleResponse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?) -> Result<T, NetworkError> {
        if let error = error {
            return .failure(.requestFailed(error))
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.invalidResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            return .failure(.serverError(statusCode: httpResponse.statusCode))
        }
        
        guard let data = data else {
            return .failure(.invalidResponse)
        }
        
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedObject)
        } catch {
            return .failure(.decodingFailed(error))
        }
    }
}
