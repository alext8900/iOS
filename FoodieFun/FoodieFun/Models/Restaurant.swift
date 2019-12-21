//
//  Restaurant.swift
//  FoodieFun
//
//  Created by Alex Thompson on 12/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct Restaurant: Codable, Equatable {
    let restauraunt_id: String
    let cuisine: String
    let name: String
    let photo_url: String
    let rating: Int
    let review: String
    let userId: String
}
