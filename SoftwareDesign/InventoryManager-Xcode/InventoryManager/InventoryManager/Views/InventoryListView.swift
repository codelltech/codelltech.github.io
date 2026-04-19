//
//  InventoryListView.swift
//  InventoryManager
//
//  Created by Christopher O'Dell on 3/22/26.
//

import SwiftUI
import SwiftData

struct InventoryListView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var auth: AuthManager

    @Query(sort: \InventoryItem.name) private var allItems: [InventoryItem]

    @State private var showAddSheet = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredItems) { item in
                    NavigationLink {
                        EditItemView(item: item)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(item.name).bold()
                            Text("Qty: \(item.quantity)")
                            Text(item.date)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Inventory")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Logout") {
                        auth.logout()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        showAddSheet = true
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddItemView()
            }
        }
    }

    private var filteredItems: [InventoryItem] {
        guard let email = auth.currentUserEmail else { return [] }
        return allItems.filter { $0.ownerEmail == email }
    }

    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredItems[index])
        }

        do {
            try modelContext.save()
        } catch {
            print("Delete failed: \(error)")
        }
    }
}
