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
                print("Error decoding user representations: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    func put(user: User1, completion: @escaping () -> Void = { }) {
        let uuid = user.identifier ?? UUID()
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = user.userRepresentation else {
                completion()
                return
            }
            
            representation.identifier = uuid.uuidString
            user.identifier = uuid
            try CoreDataStack.shared.save()
            request.httpBody = try
                JSONEncoder().encode(representation)
        } catch {
            print("Error encoding task \(user): \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                print("Error putting user to server: \(error!)")
                completion()
                return
            }
            
            completion()
        }.resume()
    }
    
    private func fetchUser(with representations: [UserRepresentation]) throws {
        let usersWithID = representations.filter { $0.identifier != nil }
        
        let identifiersToFetch = usersWithID.compactMap { rep -> UUID? in
            return UUID(uuidString: rep.identifier!)
        }
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, usersWithID))
        
        var usersToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<User1> = User1.fetchRequest()
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.perform {
            do {
                let existingUsers = try
                context.fetch(fetchRequest)
                
                for user in existingUsers {
                    guard let id = user.identifier,
                        let representation = representationsByID[id] else {
                            let moc = CoreDataStack.shared.mainContext
                            moc.delete(user)
                            continue
                    }
                    
                    user.username = representation.username
                    user.password = representation.password
                    
                    usersToCreate.removeValue(forKey: id)
                }
                
                for representation in usersToCreate.values {
                    User1(userRepresentation: representation,
                          context: context)
                }
            } catch {
                print("error fetching users for UUIDs: \(error)")
            }
        }
        
        try CoreDataStack.shared.save(context: context)
    }
}
