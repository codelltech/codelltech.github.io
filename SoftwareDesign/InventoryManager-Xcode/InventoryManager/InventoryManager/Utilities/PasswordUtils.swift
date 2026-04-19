//
//  PasswordUtils.swift
//  InventoryManager
//
//  Created by Christopher O'Dell on 3/22/26.
//

import Foundation
import CryptoKit

struct PasswordUtils {
    static func generateSalt() -> String {
        let data = Data((0..<16).map { _ in UInt8.random(in: 0...255) })
        return data.base64EncodedString()
    }

    static func hashPassword(_ password: String, salt: String) -> String {
        let combined = password + salt
        let digest = SHA256.hash(data: Data(combined.utf8))
        return Data(digest).base64EncodedString()
    }

    static func verifyPassword(_ password: String, salt: String, storedHash: String) -> Bool {
        hashPassword(password, salt: salt) == storedHash
    }
}
