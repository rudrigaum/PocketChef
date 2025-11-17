//
//  VideosViewModelProtocol.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 16/10/25.
//

import Foundation
import Combine

enum VideosState: LoadingStateful {
    case loading
    case loaded([VideoItem])
    case error(String)
    
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
}

@MainActor
protocol VideosViewModelProtocol: AnyObject {
    var statePublisher: AnyPublisher<VideosState, Never> { get }
    func fetchVideos() async
}
