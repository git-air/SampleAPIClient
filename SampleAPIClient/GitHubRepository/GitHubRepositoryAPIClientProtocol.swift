//
//  GitHubRepositoryAPIClientProtocol.swift
//  SampleAPIClient
//
//  Created by AIR on 2023/07/08.
//

import Foundation

protocol GitHubRepositoryAPIClientProtocol {
    func request(_ apiRequest: any APIRequest, completion: @escaping ResultCallback<[GitHubRepository], APIError>)
}
