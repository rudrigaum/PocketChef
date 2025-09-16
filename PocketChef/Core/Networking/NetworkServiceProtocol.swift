//
//  NetworkServiceProtocol.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 16/09/25.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(urlString: String, completion: @escaping (Result<T, NetworkError>) -> Void)
}
