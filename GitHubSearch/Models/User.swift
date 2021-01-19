//
//  User.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 14.01.2021.
//

import UIKit

class User: Codable, Hashable {
    var id: Int
    var login: String
    var avatarURLString: String
    var avatarImage: UIImage = ImageCache.publicCache.placeholderImage
    
    private enum CodingKeys: String, CodingKey {
        case id, login
        case avatarURLString = "avatar_url"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs:User, rhs:User) -> Bool {
        lhs.id == rhs.id
    }
}

struct UserSearchResponse: Codable, Hashable {
    var items: [User]
}

extension User {
    var avatarURL: URL? {
        return URL(string: avatarURLString)
    }
}
