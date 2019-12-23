//
//  SignUpController.swift
//  FoodieFun
//
//  Created by Vici Shaweddy on 12/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class SignUpController {
    typealias CompletionHandler = (Error?) -> Void
    
    private let baseURL = URL(string: "https://bw-foodiefun.herokuapp.com/api")!
    
    // create function for sign up
    func signUp(with signupData: SignUpRequest, completion: @escaping CompletionHandler) {
        let signUpURL = baseURL.appendingPathComponent("/users/register")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(signupData)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 201 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }

            if let error = error {
                completion(error)
                return
            }

            guard let data = data else {
                completion(error)
                return
            }

            let decoder = JSONDecoder()
            do {
                let user = try decoder.decode(User.self, from: data)
                LoginController.shared.token = user.token
            } catch {
                print("Error decoding token: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
}
