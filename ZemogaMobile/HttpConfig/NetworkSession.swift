//
//  NetworkSession.swift
//  ZemogaMobile
//
//  Created by Luci on 20/5/22.
//

import Foundation

protocol NetworkTask {
  func resume()
}

extension URLSessionDataTask: NetworkTask {}

protocol NetworkSession {
  func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask
  
  func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask
}

extension URLSession: NetworkSession {
  func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask {
    return dataTask(with: request, completionHandler: completion)
  }
  
  func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask {
    return dataTask(with:url, completionHandler: completion)
  }
}
