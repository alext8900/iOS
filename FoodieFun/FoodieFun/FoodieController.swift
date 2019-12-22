//
//  FoodieController.swift
//  FoodieFun
//
//  Created by Alex Thompson on 12/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

class Returns: Decodable {
    let id: String
    let username: String
    let location: String
    let email: String
}

class NetworkController {
    var baseURL = URL(string: "https://bw-foodiefun.herokuapp.com/api")!
    let dict = ["username": "",
    "password": "",
    "location": "",
    "email": "",]
    func registerUsers(with user: [String: String]) {
        baseURL.appendPathComponent("/users/register")
        print(baseURL)
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        
        let jsonData = try! JSONSerialization.data(withJSONObject: user, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("\(error)")
            }
            
            if let response = response as? HTTPURLResponse {
                print("\(response.statusCode)")
            }
            
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }.resume()
        NetworkController().registerUsers(with: dict)
    }
}






