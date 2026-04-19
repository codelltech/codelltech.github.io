//
//  User.swift
//  InventoryManager
//
//  Created by Christopher O'Dell on 3/22/26.
//

import SwiftData

@Model
final class User {
    var email: String
    var passwordHash: String
    var passwordSalt: String

    init(email: String, passwordHash: String, passwordSalt: String) {
        self.email = email
        self.passwordHash = passwordHash
        self.passwordSalt = passwordSalt
    }
}
