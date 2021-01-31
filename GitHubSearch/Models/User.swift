//
//  User.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 14.01.2021.
//

import UIKit


class User: Codable, Hashable {
    enum UserType: String, Codable {
        case organization = "Organization"
        case user = "User"
    }

    var id: Int
    var name: String?
    var login: String
    var type: UserType
    var bio: String?
    var blog: String?
    var company: String?
    var location: String?
    var email: String?
    var followers: Int?
    var following: Int?
    
    var repos: [Repository]?
    var starred: [Repository]?
    var organizations: [Organization]?
    
    var htmlURL: String
    var followersURL: String
    var followingURL: String
    var reposURL: String
    var avatarURLString: String
    var avatarImage: UIImage = ImageCache.publicCache.placeholderImage
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case login
        case type
        case bio
        case blog
        case company
        case location
        case email
        case followers
        case following
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case reposURL = "repos_url"
        case avatarURLString = "avatar_url"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs:User, rhs:User) -> Bool {
        lhs.id == rhs.id
    }
}

extension User {
    var avatarURL: URL? {
        return URL(string: avatarURLString)
    }
}
