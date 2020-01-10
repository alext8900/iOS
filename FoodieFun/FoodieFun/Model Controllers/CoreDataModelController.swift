//
//  CoreDataModelController.swift
//  FoodieFun
//
//  Created by Alex Thompson on 1/9/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class UserController {
    typealias CompletionHandler = (Error?) -> Void
    
    private let baseURL = URL(string: "https://foodiefun-3fc92.firebaseio.com/")!
    
    init() {
        fetchUserFromServer()
    }
    
    func fetchUserFromServer(completion: @escaping CompletionHandler = { _ in}) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            guard let data = data else {
                print("No data return by data task")
                completion(NSError())
                return
            }
            
            do {
                let userRepresentations = Array(try JSONDecoder().decode([String : UserRepresentation].self, from: data).values)
                
            } catch {
                
            }
        }
    }
}
