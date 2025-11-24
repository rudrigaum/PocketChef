//
//  KingfisherImageLoader.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 01/10/25.
//

import Foundation
import UIKit
import Kingfisher

@MainActor
final class KingfisherImageLoader: ImageLoading {
    func loadImage(into imageView: UIImageView, from url: URL?) {
        let placeholder = UIImage(systemName: "photo")

        imageView.kf.indicatorType = .activity

        imageView.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ]
        )
    }
}
