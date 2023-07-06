//
//  GitHubRepository.swift
//  SampleAPIClient
//
//  Created by AIR on 2023/07/06.
//

import Foundation

struct GitHubRepository: Decodable {
    let id: Int
    let name: String
    let full_name: String
    let language: String?
    let visibility: String
    let watchers: Int
}

struct GitHubReposRequest: APIRequest {
    typealias ResponseType = [GitHubRepository]
    
    var user: String
    
    var url: String {
        return "https://api.github.com/users/\(user)"
    }
    
    var path: String {
        return "/repos"
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var headers: [String : String] {
        return [:]
    }
    
    var body: Data? {
        return nil
    }
    
    var queries: [String : String] {
        return [:]
    }
    
    var timeout: TimeInterval {
        return 60
    }
}
