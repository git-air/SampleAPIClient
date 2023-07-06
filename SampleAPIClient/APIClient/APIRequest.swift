//
//  APIRequest.swift
//  SampleAPIClient
//
//  Created by AIR on 2023/07/06.
//

import Foundation

protocol APIRequest {
    associatedtype ResponseType: Decodable
    var url: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: [String: String] { get }
    var body: Data? { get }
    var queries: [String: String] { get }
    var timeout: TimeInterval { get }
    func decode(from data: Data) throws -> ResponseType
}

extension APIRequest {
    var urlRequest: URLRequest? {
        guard var urlComponents = URLComponents(string: url + path) else { return nil }
        var urlQueryItems: [URLQueryItem] = []
        queries.forEach { key, value in
            urlQueryItems.append(URLQueryItem(name: key, value: value))
        }
        urlComponents.queryItems = urlQueryItems
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        if let body = body {
            request.httpBody = body
        }
        headers.forEach { (key: String, value: String) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        return request
    }
    
    var session: URLSession {
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        config.timeoutIntervalForResource = timeout
        let session = URLSession(configuration: config)
        return session
    }
    
    func decode(from data: Data) throws -> ResponseType {
        let decoder = JSONDecoder()
        return try decoder.decode(ResponseType.self, from: data)
    }
}
