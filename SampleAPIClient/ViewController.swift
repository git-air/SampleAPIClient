//
//  ViewController.swift
//  SampleAPIClient
//
//  Created by AIR on 2023/06/30.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let g = GitHubReposAPIClient()
        g.reqestGitHubRepos { result in
            switch result {
            case .success(let data):
                print(data[0])
            case .failure(let error):
                print(error)
            }
        }
    }
}

class GitHubReposAPIClient {
    let api = DefaultAPI.shared
    let request = GitHubReposRequest()
    
    func reqestGitHubRepos(completion: @escaping ResultCallback<[GitHubRepository], APIError>) {
        api.request(request) { result in
            completion(result)
        }
    }
}

typealias ResultCallback<Value, Error> = (_ result: Result<Value, APIError>) -> Void

protocol APIClient {
    func request<T: APIRequest>(_ request: T, completion: @escaping ResultCallback<T.ResponseType, APIError>)
}

protocol APIRequest {
    associatedtype ResponseType: Decodable
    var url: String { get }
    func decode(from data: Data) throws -> ResponseType
}

extension APIRequest {
    var urlRequest: URLRequest? {
        guard let urlComponents = URLComponents(string: url) else { return nil }
        guard let url = urlComponents.url else { return nil }
        let request = URLRequest(url: url)
        return request
    }
    
    var session: URLSession {
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        config.timeoutIntervalForResource = 60
        let session = URLSession(configuration: config)
        return session
    }
    
    func decode(from data: Data) throws -> ResponseType {
        let decoder = JSONDecoder()
        return try decoder.decode(ResponseType.self, from: data)
    }
}

protocol APIResponse {
    
}

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
    
    var url: String {
        return "https://api.github.com/users/git-air/repos"
    }
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

enum APIError: Error {
    case server(Int)
    case decode(Error)
    case noResponse
    case unknown(Error)
    
    var title: String {
        switch self {
        case .server:
            return "サーバーエラー"
        case .decode:
            return "デコードエラー"
        case .noResponse:
            return "レスポンスエラー"
        case .unknown:
            return "不明なエラー"
        }
    }
    
    var description: String {
        switch self {
        case .server:
            return "サーバーエラーです。"
        case .decode:
            return "デコードエラーです。"
        case .noResponse:
            return "レスポンスエラーです。"
        case .unknown:
            return "不明なエラーです。"
        }
    }
}
