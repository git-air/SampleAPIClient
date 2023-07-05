//
//  GitHubAPITests.swift
//  SampleAPIClientTests
//
//  Created by AIR on 2023/07/05.
//

import XCTest
@testable import SampleAPIClient

final class GitHubAPITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testZenFetch() {
        let expectation = self.expectation(description: "API")
        
        GitHubZen.fetch { errorOrZen in
            switch errorOrZen {
            case let .left(error):
                XCTFail("\(error)")
                
            case let .right(zen):
                XCTAssertNotNil(zen)
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10)
    }
    
    
    func testZenFetchTwice() {
        let expectation = self.expectation(description: "API")
        
        GitHubZen.fetch { errorOrZen in
            switch errorOrZen {
            case let .left(error):
                XCTFail("\(error)")
                
            case .right(_):
                GitHubZen.fetch { errorOrZen in
                    switch errorOrZen {
                    case let .left(error):
                        XCTFail("\(error)")
                        
                    case let .right(zen):
                        XCTAssertNotNil(zen)
                        expectation.fulfill()
                    }
                }
            }
        }
        
        self.waitForExpectations(timeout: 10)
    }
    
    
    func testUser() throws {
        let response: Response = (
            statusCode: .ok,
            headers: [:],
            payload: try JSONSerialization.data(withJSONObject: [
                "id": 1,
                "login": "octocat"
            ] as [String : Any])
        )
        
        switch GitHubUser.from(response: response) {
        case let .left(error):
            XCTFail("\(error)")
            
        case let .right(user):
            XCTAssertEqual(user.id, 1)
            XCTAssertEqual(user.login, "octocat")
        }
    }
    
    
    func testUserFetch() {
        let expectation = self.expectation(description: "API")
        
        GitHubUser.fetch(byLogin: "Kuniwak") { errorOrUser in
            switch errorOrUser {
            case let .left(error):
                XCTFail("\(error)")
                
            case let .right(user):
                XCTAssertEqual(user.id, 1124024)
                XCTAssertEqual(user.login, "Kuniwak")
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10)
    }
    
}
