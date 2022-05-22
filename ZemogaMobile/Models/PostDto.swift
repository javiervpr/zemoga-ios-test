//
//  Post.swift
//  ZemogaMobile
//
//  Created by Luci on 17/5/22.
//

import Foundation
import CoreData

struct PostDto : Codable {
    
    var id: Int
    var userId: Int
    var title: String
    var body: String
    
}
