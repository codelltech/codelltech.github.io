//
//  InventoryManagerApp.swift
//  InventoryManager
//
//  Created by Christopher O'Dell on 3/22/26.
//

import SwiftUI
import SwiftData

@main
struct InventoryManagerApp: App {
    @StateObject private var auth = AuthManager()

    var body: some Scene {
        WindowGroup {
            if auth.currentUserEmail == nil {
                LoginView()
                    .environmentObject(auth)
            } else {
                InventoryListView()
                    .environmentObject(auth)
            }
        }
        .modelContainer(for: [User.self, InventoryItem.self])
    }
}
