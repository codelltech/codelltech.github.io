//
//  AuthManager.swift
//  InventoryManager
//
//  Created by Christopher O'Dell on 3/22/26.
//

import Foundation
import SwiftData

@MainActor
final class AuthManager: ObservableObject {
    @Published var currentUserEmail: String? = nil

    func registerUser(email: String, password: String, context: ModelContext) throws -> Bool {
        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate { $0.email == email }
        )
        let existing = try context.fetch(descriptor)

        if !existing.isEmpty {
            return false
        }

        let salt = PasswordUtils.generateSalt()
        let hash = PasswordUtils.hashPassword(password, salt: salt)

        let user = User(email: email, passwordHash: hash, passwordSalt: salt)
        context.insert(user)
        try context.save()

        currentUserEmail = email
        return true
    }

    func loginUser(email: String, password: String, context: ModelContext) throws -> Bool {
        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate { $0.email == email }
        )
        let users = try context.fetch(descriptor)

        guard let user = users.first else {
            return false
        }

        let ok = PasswordUtils.verifyPassword(password,
                                              salt: user.passwordSalt,
                                              storedHash: user.passwordHash)

        if ok {
            currentUserEmail = email
        }

        return ok
    }

    func logout() {
        currentUserEmail = nil
    }
}
