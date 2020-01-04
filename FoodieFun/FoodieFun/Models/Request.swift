//
//  Request.swift
//  FoodieFun
//
//  Created by Vici Shaweddy on 12/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct SignUpRequest: Equatable, Codable {
    let username: String
    let password: String
    let location: String
    let email: String
}

struct LoginRequest: Equatable, Codable {
    let username: String
    let password: String
}

struct RestaurantRequest: Equatable, Codable {
    let name: String
    let cuisine: String
    let location: String
    let hour_open: Int
    let hour_closed: Int
    let days_open: String
    let user_id: Int
    let photo_url: String
}

struct ReviewRequest: Equatable, Codable {
    let restaurant_id: Int
    let cuisine: String
    let name: String
    let photo_url: String
    let rating: Int
    let review: String
    let user_id: String
}
