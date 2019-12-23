//
//  User.swift
//  FoodieFun
//
//  Created by Alex Thompson on 12/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct User: Codable, Equatable {
    let id: UInt
    let username: String
    let password: String
    let location: String
    let email: String
    let token: String
}
