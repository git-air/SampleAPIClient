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
        // コードは StartSmallForAPITests.testRequestAndResopnse から拝借してきた。
        
        let expectation = self.expectation(description: "API")
        
        let input: Input = (
            url: URL(string: "https://api.github.com/zen")!,
            queries: [],
            headers: [:],
            methodAndPayload: .get
        )
        
        WebAPI.call(with: input) { output in
            switch output {
            case .noResponse:
                XCTFail("No response")
                
            case let .hasResponse(response):
                let errorOrZen = GitHubZen.from(response: response)
                XCTAssertNotNil(errorOrZen.right)
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10)
    }
    
}
