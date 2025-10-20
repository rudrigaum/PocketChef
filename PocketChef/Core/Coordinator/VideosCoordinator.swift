//
//  VideosCoordinator.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 16/10/25.
//

import Foundation
import UIKit
import SafariServices

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
        let videoId = videoItem.id.videoId
        guard let url = URL(string: "https://www.youtube.com/watch?v=\(videoId)") else {
            presentAlert(title: "Invalid Video", message: "This video could not be opened.")
            return
        }
        
        let safariViewController = SFSafariViewController(url: url)
        navigationController.present(safariViewController, animated: true)
    }
}
