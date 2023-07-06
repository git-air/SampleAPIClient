//
//  APIClient.swift
//  SampleAPIClient
//
//  Created by AIR on 2023/07/06.
//

import Foundation

typealias ResultCallback<Value, Error> = (_ result: Result<Value, APIError>) -> Void

protocol APIClient {
    func request<T: APIRequest>(_ request: T, completion: @escaping ResultCallback<T.ResponseType, APIError>)
}

class DefaultAPI: APIClient {
    static let shared = DefaultAPI()
    
    private init() {}
    
    func request<T>(_ request: T, completion: @escaping ResultCallback<T.ResponseType, APIError>) where T : APIRequest {
        guard let newRequest = request.urlRequest else { return }
        let session = request.session
        let task = session.dataTask(with: newRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(APIError.unknown(error)))
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse else {
                completion(.failure(APIError.noResponse))
                return
            }
            if case 200..<300 = response.statusCode {
                do {
                    let model = try request.decode(from: data)
                    completion(.success(model))
                } catch let decodeError {
                    completion(.failure(APIError.decode(decodeError)))
                }
            } else {
                completion(.failure(APIError.server(response.statusCode)))
            }
        }
        task.resume()
    }
}
