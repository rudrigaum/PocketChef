//
//  MockSearchHistoryStore.swift
//  PocketChefTests
//
//  Created by Rodrigo Cerqueira Reis on 02/10/25.
//

import Foundation
@testable import PocketChef

final class MockSearchHistoryStore: SearchHistoryStore {
    
    var mockHistory: [String] = []
    
    func save(searchTerm term: String) {
        mockHistory.removeAll { $0 == term }
        mockHistory.insert(term, at: 0)
    }
    
    func getSearchHistory() -> [String] {
        return mockHistory
    }
    
    func clearSearchHistory() {
        mockHistory.removeAll()
    }
    
    func remove(searchTerm term: String) {
        mockHistory.removeAll { $0 == term }
    }
}
