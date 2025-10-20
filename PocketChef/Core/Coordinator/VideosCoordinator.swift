//
//  VideosCoordinator.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 16/10/25.
//

import Foundation
import UIKit

@MainActor
final class VideosCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = VideosViewModel()
        let viewController = VideosViewController(viewModel: viewModel)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: false)
    }
}

// MARK: - VideosViewControllerDelegate
extension VideosCoordinator: VideosViewControllerDelegate {
    func videosViewController(_ controller: VideosViewController, didSelectVideo videoItem: VideoItem) {
        print("Coordinator was told to play video with ID: \(videoItem.id.videoId)")
    }
}
