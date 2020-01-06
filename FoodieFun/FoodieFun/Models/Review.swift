//
//  Review.swift
//  FoodieFun
//
//  Created by Vici Shaweddy on 1/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct Review: Codable, Equatable {
    let id: Int
    let restaurant_id: Int
    let cuisine: String
    let name: String
    let photo_url: String
    let rating: Int
    let review: String
    let user_id: Int
}

