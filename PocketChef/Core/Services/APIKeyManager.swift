//
//  APIKeyManager.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 20/10/25.
//

import Foundation

enum APIKeyManager {
    
    static var youTubeAPIKey: String {
        guard let filePath = Bundle.main.path(forResource: "APIKeys", ofType: "plist") else {
            fatalError("Couldn't find file 'APIKeys.plist'. Make sure it's added to the project.")
        }
        
        guard let plist = NSDictionary(contentsOfFile: filePath) else {
            fatalError("Couldn't load 'APIKeys.plist'. Check its format.")
        }
        
        guard let key = plist.object(forKey: "YouTubeAPIKey") as? String else {
            fatalError("Couldn't find key 'YouTubeAPIKey' in 'APIKeys.plist'.")
        }
        
        return key
    }
}


