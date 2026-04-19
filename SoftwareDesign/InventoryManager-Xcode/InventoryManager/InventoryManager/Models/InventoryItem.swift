//
//  InventoryItem.swift
//  InventoryManager
//
//  Created by Christopher O'Dell on 3/22/26.
//

import SwiftData

@Model
final class InventoryItem {
    var name: String
    var quantity: Int
    var date: String
    var ownerEmail: String

    init(name: String, quantity: Int, date: String, ownerEmail: String) {
        self.name = name
        self.quantity = quantity
        self.date = date
        self.ownerEmail = ownerEmail
    }
}
