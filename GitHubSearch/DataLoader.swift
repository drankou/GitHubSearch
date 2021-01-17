//
//  DataLoader.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 15.01.2021.
//

import Foundation

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
}


class DataLoader {
    func request(_ endpoint: Endpoint, completion: @escaping (Result<[User], EndpointError>) -> Void) {
        guard let url = endpoint.url else {
            return completion(.failure(.invalidURL))
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                return completion(.failure(.serverError(error: error)))
            }
            
            if let jsonData = data {
                do {
                    let userSearchResponse = try JSONDecoder().decode(UserSearchResponse.self, from: jsonData)
                    completion(.success(userSearchResponse.items))
                } catch {
                    completion(.failure(.jsonDecoderError(error: error)))
                }
            } else {
                completion(.failure(.dataNotAvailable))
            }
        }
        
        task.resume()
    }
}
