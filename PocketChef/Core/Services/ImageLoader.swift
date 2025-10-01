//
//  ImageLoader.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 01/10/25.
//

import Foundation

@MainActor
enum ImageLoader {
    static var shared: ImageLoading = KingfisherImageLoader()
}
