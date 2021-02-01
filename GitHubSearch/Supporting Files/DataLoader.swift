//
//  DataLoader.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 15.01.2021.
//

import Foundation
import Alamofire
import AlamofireImage
import PromiseKit

enum EndpointError: Error {
    case dataNotAvailable
    case invalidURL
    case jsonDecoderError(error: Error)
    case serverError(error: Error)
}

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
}

extension Endpoint {
    static func searchUsers(matching query: String) -> Endpoint {
        return Endpoint(
            path: "/search/users",
            queryItems: [
                URLQueryItem(name: "q", value: query)
            ]
        )
    }
    
    static func detail(for user: String) -> Endpoint {
        return Endpoint(
            path: "/users/\(user)",
            queryItems: []
        )
    }
    
    static func starred(by user: String) -> Endpoint {
        return Endpoint(
            path: "/users/\(user)/starred",
            queryItems: []
        )
    }
    
    static func repos(of user: String) -> Endpoint {
        return Endpoint(
            path: "/users/\(user)/repos",
            queryItems: []
        )
    }
    
    static func organizations(of user: String) -> Endpoint {
        return Endpoint(
            path: "/users/\(user)/orgs",
            queryItems: []
        )
    }
}


class DataLoader {
    func getUserDetail(for user: String) -> Promise<User> {
        return request(.detail(for: user), of: User.self)
    }
    
    func getStarred(for user: String) -> Promise<[Repository]> {
        return request(.starred(by: user), of: [Repository].self)
    }
    
    func getRepos(for user: String) -> Promise<[Repository]> {
        return request(.repos(of: user), of: [Repository].self)
    }
    
    func getOrganizations(for user: String) -> Promise<[Organization]> {
        return request(.organizations(of: user), of: [Organization].self)
    }
    
    func searchUsers(query: String) -> Promise<[User]> {
       request(.searchUsers(matching: query), of: UsersSearchResponse.self)
        .then { (response) -> Promise<[User]> in
            Promise.value(response.all)
        }
    }
    
    func request<T:Decodable>(_ endpoint: Endpoint, of type: T.Type) -> Promise<T>{
        return Promise { seal in
            guard let url = endpoint.url else {
                return seal.reject(AFError.invalidURL(url: endpoint.url!))
            }
                
            AF.request(url)
                .validate()
                .responseDecodable(of: T.self) { (response) in
                    switch response.result{
                    case.success(let value):
                        seal.fulfill(value)
                    case.failure(let error):
                        return seal.reject(error)
                    }
                }
        }
    }
}
