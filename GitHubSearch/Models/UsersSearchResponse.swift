//
//  UsersSearchResponse.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 31.01.2021.
//

import Foundation

struct UsersSearchResponse: Codable, Hashable {
    var all: [User]
    
    private enum CodingKeys: String, CodingKey {
        case all = "items"
    }
}
