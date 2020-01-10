//
//  User+Convenience.swift
//  FoodieFun
//
//  Created by Alex Thompson on 1/9/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData


extension User1 {
    var userRepresentation: UserRepresentation? {
        guard let username = username else { return nil }
        return UserRepresentation(username: username, password: password!, identifier: identifier?.uuidString ?? UUID().uuidString)
    }
    convenience init(username: String,
                     password: String,
                     identifier: UUID = UUID(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.username = username
        self.identifier = identifier
        self.password = password
    }
    
    @discardableResult convenience init?(userRepresentation: UserRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let identifierString = userRepresentation.identifier,
            let identifier = UUID(uuidString: identifierString) else { return nil }
        
        self.init(username: userRepresentation.username,
                  password: userRepresentation.password,
                  identifier: identifier,
                  context: context)
    }
}



