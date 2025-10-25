//
//  Theme.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 24/10/25.
//

import Foundation
import UIKit

enum Theme {
    
    // MARK: - Colors
    enum Colors {
        static let accent = UIColor(named: "accentColor")
        static let background = UIColor.systemBackground
        static let primaryText = UIColor.label
        static let secondaryText = UIColor.secondaryLabel
        static let separator = UIColor.systemGray4
    }
    
    // MARK: - Fonts
    enum Fonts {
        static let largeTitle = UIFont.preferredFont(forTextStyle: .largeTitle)
        static let headline = UIFont.preferredFont(forTextStyle: .headline)
        static let body = UIFont.preferredFont(forTextStyle: .body)
        static let subheadline = UIFont.preferredFont(forTextStyle: .subheadline)
    }
    
    // MARK: - Spacing
    enum Spacing {
        static let small: CGFloat = 8.0
        static let medium: CGFloat = 12.0
        static let standard: CGFloat = 16.0
        static let large: CGFloat = 24.0
    }
}
