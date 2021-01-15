//
//  User.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 14.01.2021.
//

import UIKit

struct User: Hashable {
    var id: String
    var name: String
    var username: String
    var email: String
    var image: UIImage
    var status: UserStatus
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}

enum UserStatus {
    case focusing
}
