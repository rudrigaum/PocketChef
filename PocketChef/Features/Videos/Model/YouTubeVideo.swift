//
//  YouTubeVideo.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 16/10/25.
//

import Foundation

struct YouTubeSearchResponse: Decodable {
    let items: [VideoItem]
}

struct VideoItem: Decodable, Identifiable {
    let id: VideoId
    let snippet: Snippet
}

struct VideoId: Decodable, Hashable {
    let videoId: String
}

struct Snippet: Decodable {
    let title: String
    let description: String
    let thumbnails: Thumbnails
}

struct Thumbnails: Decodable {
    let high: ThumbnailInfo
}

struct ThumbnailInfo: Decodable {
    let url: String
}
