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
    var cuisine: String
    var name: String
    var photo_url: String
    var rating: Int
    var review: String
    let user_id: Int
}

