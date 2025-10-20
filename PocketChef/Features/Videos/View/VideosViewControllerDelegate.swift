//
//  VideosViewControllerDelegate.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 20/10/25.
//

import Foundation

@MainActor
protocol VideosViewControllerDelegate: AnyObject {
    func videosViewController(_ controller: VideosViewController, didSelectVideo videoItem: VideoItem)
}
