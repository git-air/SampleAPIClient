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
        
        // GitHub Zen API には入力パラメータがないので、関数呼び出し時には
        // 引数は指定しなくて済むようにしたい。また、API 呼び出しは非同期なので、
        // コールバックをとるはず（注: GitHubZen.fetch はあとで定義する）。
        GitHubZen.fetch { errorOrZen in
            // エラーかレスポンスがきたらコールバックが実行されて欲しい。
            // できれば、結果はすでに変換済みの GitHubZen オブジェクトを受け取りたい。
            
            switch errorOrZen {
            case let .left(error):
                // エラーがきたらわかりやすいようにする。
                XCTFail("\(error)")
                
            case let .right(zen):
                // 結果をきちんと受け取れたことを確認する。
                XCTAssertNotNil(zen)
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10)
    }
    
    
    // API を二度呼ぶ方もかなり可読性が上がっている。
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
    
}
