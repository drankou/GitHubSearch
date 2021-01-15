//
//  User.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 14.01.2021.
//

import UIKit

struct User: Codable, Hashable {
    var id: Int
    var login: String
    var avatarURL: String
    
    private enum CodingKeys: String, CodingKey {
        case id, login
        case avatarURL = "avatar_url"
    }
}

struct UserSearchResponse: Codable, Hashable {
    var items: [User]
}
