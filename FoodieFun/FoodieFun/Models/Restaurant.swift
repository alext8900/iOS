//
//  Restaurant.swift
//  FoodieFun
//
//  Created by Alex Thompson on 12/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct Restaurant: Codable, Equatable {
    let id: String
    let name: String
    let cuisine: String
    let location: String
    let hour_open: Int
    let hour_closed: Int
    let days_open: String
    let user_id: Int
    let photo_url: String
}
