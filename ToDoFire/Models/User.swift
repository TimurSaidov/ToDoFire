//
//  User.swift
//  ToDoFire
//
//  Created by Timur Saidov on 08/12/2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import Foundation
import Firebase

struct MyUser {
    let id: String
    let email: String
    
    init(user: User) {
        self.id = user.uid
        self.email = user.email!
    }
}
