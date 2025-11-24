//
//  APIKeyManager.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 20/10/25.
//

import Foundation

public enum APIKeyManager {
    
    private enum KeyName: String {
        case gemini = "GEMINI_API_KEY"
        case youtube = "YOUTUBE_API_KEY"
    }
    
    private static let plistDict: NSDictionary = {
        guard let filePath = Bundle.main.path(forResource: "APIKeys", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: filePath) else {
            fatalError("🚨 ERROR: APIKeys.plist not found or cannot be loaded.")
        }
        return dict
    }()

    private static func getRequiredKey(forKey key: KeyName) -> String {
        let keyName = key.rawValue
        guard let value = plistDict.object(forKey: keyName) as? String, !value.isEmpty else {
            fatalError("🚨 ERROR: Missing or empty API key for '\(keyName)' in APIKeys.plist.")
        }
        return value
    }
    
    // MARK: - Public API Keys
    public static var geminiAPIKey: String {
        return getRequiredKey(forKey: .gemini)
    }

    public static var youTubeAPIKey: String {
        return getRequiredKey(forKey: .youtube)
    }
}
