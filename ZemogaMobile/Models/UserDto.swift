//
//  User.swift
//  ZemogaMobile
//
//  Created by Luci on 17/5/22.
//

import Foundation
import CoreData

struct UserDto: Codable {
    
    var id: Int
    var name: String
    var email: String
    var phone: String
    var website: String
    
}
