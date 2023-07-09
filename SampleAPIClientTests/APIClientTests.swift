//
//  APIClientTests.swift
//  SampleAPIClientTests
//
//  Created by AIR on 2023/07/06.
//

import XCTest
@testable import SampleAPIClient

final class APIClientTests: XCTestCase {
    
    private var mockRepositoryRequest: MockRepositoryRequest!
    
    override func setUp() {
    }
    
    override func setUpWithError() throws {
        mockRepositoryRequest = MockRepositoryRequest()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAPIRequest() throws {
        let githubRequest = GitHubReposRequest(user: "test")
        XCTAssertEqual(githubRequest.url, "https://api.github.com/users/test")
        XCTAssertEqual(githubRequest.httpMethod.rawValue, "GET")
        XCTAssertEqual((githubRequest.urlRequest?.url)!, URL(string:  "https://api.github.com/users/test/repos"))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

final class MockRepositoryRequest: GitHubRepositoryAPIClientProtocol {
    lazy var requestResult: Result<[GitHubRepository], APIError> = .success(mockRepositories)
    var returnRepositories: [GitHubRepository]?
    let mockRepositories: [GitHubRepository] = [
        GitHubRepository(id: 1, name: "name1", full_name: "full_name1", language: "Swift", visibility: "public", watchers: 1),
        GitHubRepository(id: 2, name: "name2", full_name: "full_name2", language: "Python", visibility: "public", watchers: 2)
    ]
    
    func request(_ apiRequest: any APIRequest, completion: @escaping ResultCallback<[GitHubRepository], APIError>) {
        completion(requestResult)
        switch requestResult {
        case .success:
            returnRepositories = mockRepositories
        case .failure:
            returnRepositories = nil
        }
    }
}
