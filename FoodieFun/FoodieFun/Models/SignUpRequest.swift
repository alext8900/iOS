//
//  SignUpRequest.swift
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
