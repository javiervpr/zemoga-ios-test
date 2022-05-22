//
//  Comment.swift
//  ZemogaMobile
//
//  Created by Luci on 17/5/22.
//

import Foundation
import CoreData

struct CommentDto: Codable {
    
    var id: Int
    var postId: Int
    var name: String
    var body: String
    
}
