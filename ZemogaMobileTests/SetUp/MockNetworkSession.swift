//
//  MockNetworkSession.swift
//  ZemogaMobileTests
//
//  Created by Luci on 20/5/22.
//

import XCTest
@testable import ZemogaMobile

class MockNetworkSession: NetworkSession {
  func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask {

    let bundle = Bundle(for: type(of: self))
    guard let url = bundle.url(forResource: "posts", withExtension: "json") else {
      XCTFail("missing file posts.json")
      return MockNetworkTask()
    }
    let json = try! Data(contentsOf: url)
    completion(json, nil, nil)
    return MockNetworkTask()
  }
  
  func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask {
      let bundle = Bundle(for: type(of: self))
      guard let url = bundle.url(forResource: "posts", withExtension: "json") else {
        XCTFail("missing file posts.json")
        return MockNetworkTask()
      }
      let json = try! Data(contentsOf: url)
      completion(json, HTTPURLResponse(url: URL(string: "testing.com")!, statusCode: 200, httpVersion: nil, headerFields: nil), nil)
    return MockNetworkTask()
  }
}

class MockNetworkErrorSession: NetworkSession {
  func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask {
    completion(nil, nil, error)
    return MockNetworkTask()
  }
  
  func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask {
    completion(nil, nil, error)
    return MockNetworkTask()
  }
  
  var error: ApiError?
}

enum ApiError: Error {
  case jsonError
}

class MockNetworkTask: NetworkTask {
  func resume() {
    
  }
}
