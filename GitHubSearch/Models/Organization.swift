//
//  Organization.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 31.01.2021.
//

import Foundation

class Organization: Codable, Hashable  {
    var id: Int
    var login: String
    var description: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Organization, rhs: Organization) -> Bool {
        lhs.id == rhs.id
    }
}
