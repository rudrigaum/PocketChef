//
//  VideosViewModelProtocol.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 16/10/25.
//

import Foundation
import Combine

enum VideosState {
    case loading
    case loaded([VideoItem])
    case error(String)
}

@MainActor
protocol VideosViewModelProtocol: AnyObject {
    var statePublisher: AnyPublisher<VideosState, Never> { get }
    func fetchVideos() async
}
