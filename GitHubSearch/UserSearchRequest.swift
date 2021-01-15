//
//  UserSearchRequest.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 15.01.2021.
//

import Foundation

enum UserSearchError: Error {
    case dataNotAvailable
    case jsonDecoderError(error: Error)
    case serverError(error: Error)
}

struct UserSearchRequest {
    let resourceURL: URL
    
    init(query: String) {
        let resourceString = "https://api.github.com/search/users?q=\(query)"
        guard let resourceURL = URL(string: resourceString) else {fatalError("Invalid resource string for user search request")}
        self.resourceURL = resourceURL
    }
    
    func search(completion: @escaping (Result<[User], UserSearchError>) -> Void) {
        let task = URLSession.shared.dataTask(with: resourceURL) { (data, response, error) in
            if let error = error {
                completion(.failure(.serverError(error: error)))
                return
            }
            
            if let jsonData = data {
                let decoder = JSONDecoder()
                
                do {
                    let userSearchResponse = try decoder.decode(UserSearchResponse.self, from: jsonData)
                    completion(.success(userSearchResponse.items))
                    return
                } catch {
                    completion(.failure(.jsonDecoderError(error: error)))
                    return
                }
            } else {
                completion(.failure(.dataNotAvailable))
                return
            }
        }
        
        task.resume()
    }
}
