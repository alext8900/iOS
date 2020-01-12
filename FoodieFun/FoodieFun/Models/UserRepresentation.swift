//
//  UserRepresentation.swift
//  FoodieFun
//
//  Created by Alex Thompson on 1/9/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

struct UserRepresentation: Codable {
    var username: String
    var password: String
    var identifier: String?
    var restaurant: String
    var location: String
}
