//
//  ImageLoading.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 01/10/25.
//

import Foundation
import UIKit

@MainActor
protocol ImageLoading {
    func loadImage(into imageView: UIImageView, from url: URL?)
}
