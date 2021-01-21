//
//  Repository.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 19.01.2021.
//

import Foundation

class Repository: Codable {
    var id: Int
    var name: String
    var fullName: String
    var owner: User?
    var fork: Bool
    var description: String
    var url: String
    var language: String
    var stargazersCount: Int
    var watchersCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case owner
        case fork
        case description
        case url
        case language
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
    }
}

class License: Codable {
    var name: String
}
