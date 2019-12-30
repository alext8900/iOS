//
//  LoginController.swift
//  FoodieFun
//
//  Created by Vici Shaweddy on 12/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class LoginController {
    static var shared = LoginController()
    
    typealias CompletionHandler = (Error?) -> Void
    
    private let baseURL = URL(string: "https://bw-foodiefun.herokuapp.com/api")!
    var token: String?
    
    func login(with loginData: LoginRequest, completion: @escaping CompletionHandler = { _ in}) {
        let requestURL = baseURL.appendingPathComponent("/users/login")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(loginData)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error { completion(error); return }
            guard let data = data else { completion(NSError()); return }
            
            let decoder = JSONDecoder()
            
            do {
                let user = try decoder.decode(User.self, from: data)
                self.token = user.token
            } catch {
                print("Error decoding token: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
}
