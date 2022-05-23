//
//  NetworkServiceTests.swift
//  ZemogaMobileTests
//
//  Created by Luci on 20/5/22.
//

import XCTest
@testable import ZemogaMobile

class NetworkServiceTests: XCTestCase {

    var networkService: NetworkService!
    
    override func setUpWithError() throws {
        self.networkService = NetworkService.shared
        self.networkService.session = MockNetworkSession()
    }

    override func tearDownWithError() throws {
     
    }

    func testHttpRequest() throws {
        let expect = expectation(description: "fetch posts")
        self.networkService.makeAGet(url: Constants.POST_ENDPOINT, enableLoading: true) { (posts: [PostDto]) in
            XCTAssertNotNil(posts)
            XCTAssertEqual(posts.count, 5)
            XCTAssertEqual(posts.last?.id, 100)
        } onError: { (error: Any) in
            XCTFail("Could not fetch posts")
        
        } onComplete: {
            expect.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testHttpRequestError() throws {
        let mockErrorSession = MockNetworkErrorSession()
        mockErrorSession.error = .jsonError
        self.networkService.session = mockErrorSession
        let expect = expectation(description: "fetch posts")
        self.networkService.makeAGet(url: Constants.POST_ENDPOINT, enableLoading: true) { (posts: [PostDto]) in
            XCTFail("Could not manage http errors")
        } onError: { (error: Any) in
            XCTAssertNotNil(error)
        } onComplete: {
            expect.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)
    }

}
