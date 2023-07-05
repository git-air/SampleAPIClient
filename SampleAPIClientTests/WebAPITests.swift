//
//  WebAPITests.swift
//  SampleAPIClientTests
//
//  Created by AIR on 2023/07/03.
//

import XCTest

final class WebAPITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRequest() {
        // リクエストを作成する。
        let input: Request = (
            // GitHub の Zen API を指定。
            url: URL(string: "https://api.github.com/zen")!,
            
            // Zen API はパラメータを取らない。
            queries: [],
            
            // 特にヘッダーもいらない。
            headers: [:],
            
            // HTTP メソッドは GET のみ対応している。
            methodAndPayload: .get
        )
        
        // この内容で API を呼び出す（注: WebAPI.call は後で定義する）。
        WebAPI.call(with: input)
    }
    
    func testResopnse() {
        // 仮のレスポンスを定義する。
        let response: Response = (
            statusCode: .ok,
            headers: [:],
            payload: "this is a response text".data(using: .utf8)!
        )
        
        // GitHubZen.from 関数を呼び出してみる。
        let errorOrZen = GitHubZen.from(response: response)
        
        // 結果は、エラーか禅なフレーズのどちらか。
        switch errorOrZen {
        case let .left(error):
            // 上の仮のレスポンスであれば、エラーにはならないはず。
            // そういう場合は、XCTFail という関数でこちらにきてしまったことをわかるようにする。
            XCTFail("\(error)")
            
        case let .right(zen):
            // 上の仮のレスポンスの禅なフレーズをちゃんと読み取れたかどうか検証したい。
            // そういう場合は、XCTAssertEqual という関数で内容があっているかどうかを検証する。
            XCTAssertEqual(zen.text, "this is a response text")
        }
    }
    
    func testRequestAndResopnse() {
        let expectation = self.expectation(description: "API を待つ")
        
        // これまでと同じようにリクエストを作成する。
        let input: Input = (
            url: URL(string: "https://api.github.com/zen")!,
            queries: [],
            headers: [:],
            methodAndPayload: .get
        )
        
        // このリクエストで API を呼び出す。
        // WebAPI.call の結果は、非同期なのでコールバックになるはず。
        // また、コールバックの引数は Output 型（レスポンスありか通信エラー）になるはず。
        // （注: WebAPI.call がコールバックを受け取れるようにするようにあとで修正する）
        WebAPI.call(with: input) { output in
            // サーバーからのレスポンスが帰ってきた。
            
            // Zen API のレスポンスの内容を確認する。
            switch output {
            case let .noResponse(connectionError):
                // もし、通信エラーが起きていたらわかるようにしておく。
                XCTFail("\(connectionError)")
                
                
            case let .hasResponse(response):
                // レスポンスがちゃんときていた場合は、わかりやすいオブジェクトへと
                // 変換してみる。
                let errorOrZen = GitHubZen.from(response: response)
                
                // 正しく呼び出せていれば GitHubZen が帰ってくるはずなので、
                // 右側が nil ではなく値が入っていることを確認する。
                XCTAssertNotNil(errorOrZen.right)
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10)
    }
}
