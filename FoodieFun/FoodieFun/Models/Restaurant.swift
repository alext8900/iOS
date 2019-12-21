//
//  Restaurant.swift
//  FoodieFun
//
//  Created by Alex Thompson on 12/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct Restaurant: Codable, Equatable {
    let restaurauntId: String
    let cuisine: String
    let name: String
    let photoUrl: String
    let rating: Int
    let review: String
    let userId: String
}
