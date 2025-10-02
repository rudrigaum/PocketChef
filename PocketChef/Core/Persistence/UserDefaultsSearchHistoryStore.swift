//
//  UserDefaultsSearchHistoryStore.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 01/10/25.
//

import Foundation

final class UserDefaultsSearchHistoryStore: SearchHistoryStore {
    
    // MARK: - Private Properties
    private let userDefaults: UserDefaults
    private static let historyKey = "SearchHistory"
    private let maxHistoryCount = 10
    
    // MARK: - Initialization
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - SearchHistoryStore Conformance
    func save(searchTerm term: String) {
        let trimmedTerm = term.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTerm.isEmpty else { return }
        
        var history = getSearchHistory()
        history.removeAll { $0.lowercased() == trimmedTerm.lowercased() }
        history.insert(trimmedTerm, at: 0)
        
        let limitedHistory = Array(history.prefix(maxHistoryCount))
        userDefaults.set(limitedHistory, forKey: Self.historyKey)
    }
    
    func remove(searchTerm term: String) {
        var history = getSearchHistory()
        history.removeAll { $0.lowercased() == term.lowercased() }
        userDefaults.set(history, forKey: Self.historyKey)
    }
    
    func getSearchHistory() -> [String] {
        return userDefaults.stringArray(forKey: Self.historyKey) ?? []
    }
    
    func clearSearchHistory() {
        userDefaults.removeObject(forKey: Self.historyKey)
    }
}
