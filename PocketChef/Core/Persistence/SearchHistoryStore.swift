//
//  SearchHistoryStore.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 01/10/25.
//

import Foundation

protocol SearchHistoryStore {
    func save(searchTerm term: String)
    func getSearchHistory() -> [String]
    func clearSearchHistory()
    func remove(searchTerm term: String)
}
