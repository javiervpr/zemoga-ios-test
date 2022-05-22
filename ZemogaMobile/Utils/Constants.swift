//
//  Utils.swift
//  ZemogaMobile
//
//  Created by Luci on 17/5/22.
//

import Foundation

struct Constants {
    
    // MARK: Base url
    static let URLSERVICE = "https://jsonplaceholder.typicode.com"
    
    // MARK: Post urls
    static let POST_ENDPOINT = "\(URLSERVICE)/posts"
    static func COMMENTS_ENDPOINT(postId: String) -> String {
        return "\(Constants.POST_ENDPOINT)/\(postId)/comments"
        
    }
    
    // MARK: User urls
    static let USERS_ENDPOINT = "\(URLSERVICE)/users"
    static func USER_ENDPOINT(userId: String) -> String {
        return "\(Constants.USERS_ENDPOINT)/\(userId)"
    }
    
    // MARK: HTTP Messages
    static let HTTP_ERROR = "An error occurred while making the request. Please try again."
    
    // MARK: Posts messages
    static let EMPTY_POSTS = "We don't have posts to show"
    static let EMPTY_FAVORITE_LIST = "You don't have favorite posts yet"
}
