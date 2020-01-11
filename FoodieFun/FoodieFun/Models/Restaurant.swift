//
//  Restaurant.swift
//  FoodieFun
//
//  Created by Alex Thompson on 12/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct Restaurant: Codable, Equatable {
    let id: Int
    var name: String
    var cuisine: String
    var location: String
    var hour_open: Int
    var hour_closed: Int
    var days_open: String
    let user_id: Int
    var photo_url: String
}
