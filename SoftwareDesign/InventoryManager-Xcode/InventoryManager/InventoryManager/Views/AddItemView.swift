//
//  AddItemView.swift
//  InventoryManager
//
//  Created by Christopher O'Dell on 3/22/26.
//

import SwiftUI
import SwiftData

struct AddItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var auth: AuthManager

    @State private var name = ""
    @State private var quantity = ""
    @State private var date = ""
    @State private var message = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Item Name", text: $name)
                TextField("Quantity", text: $quantity)
                    .keyboardType(.numberPad)
                TextField("Date", text: $date)

                if !message.isEmpty {
                    Text(message).foregroundColor(.red)
                }
            }
            .navigationTitle("Add Item")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") { saveItem() }
                }
            }
        }
    }

    private func saveItem() {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            message = "Enter item name."
            return
        }

        guard let qty = Int(quantity), qty >= 0 else {
            message = "Enter a valid quantity."
            return
        }

        guard let email = auth.currentUserEmail else {
            message = "No logged in user."
            return
        }

        let item = InventoryItem(
            name: name.trimmingCharacters(in: .whitespaces),
            quantity: qty,
            date: date.trimmingCharacters(in: .whitespaces),
            ownerEmail: email
        )

        modelContext.insert(item)

        do {
            try modelContext.save()
            dismiss()
        } catch {
            message = "Save failed."
        }
    }
}
