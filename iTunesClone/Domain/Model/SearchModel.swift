//
//  SearchModel.swift
//  iTunesClone
//
//  Created by hwijinjeong on 4/7/24.
//

import Foundation

// MARK: - SearchModel
struct SearchModel: Codable {
    let resultCount: Int
    let results: [SearchResult]
}

struct SearchResult: Codable {
    let artistName: String
    let trackName: String
}
