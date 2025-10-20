//
//  VideosViewModel.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 20/10/25.
//

import Foundation
import Combine

@MainActor
final class VideosViewModel: VideosViewModelProtocol {
    
    // MARK: - Publishers
    var statePublisher: AnyPublisher<VideosState, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Private Properties
    private let stateSubject = CurrentValueSubject<VideosState, Never>(.loading)
    private let networkService: NetworkServiceProtocol
    
    private let baseURL = "https://www.googleapis.com/youtube/v3/search"

    // MARK: - Initialization
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - View Actions
    func fetchVideos() async {
        stateSubject.send(.loading)
        
        do {
            guard let url = buildYouTubeURL() else {
                throw NetworkError.invalidURL
            }
            
            let response: YouTubeSearchResponse = try await networkService.request(urlString: url)
            
            stateSubject.send(.loaded(response.items))
            
        } catch {
            stateSubject.send(.error(error.localizedDescription))
        }
    }
    
    // MARK: - Private Methods
    private func buildYouTubeURL() -> String? {
        let query = "easy dinner recipes"
        let apiKey = APIKeyManager.youTubeAPIKey
        
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "part", value: "snippet"),
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "type", value: "video"),
            URLQueryItem(name: "maxResults", value: "20")
        ]
        
        return components?.url?.absoluteString
    }
}
