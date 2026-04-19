//
//  EditItemView.swift
//  InventoryManager
//
//  Created by Christopher O'Dell on 3/22/26.
//

import SwiftUI
import SwiftData

struct EditItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let item: InventoryItem

    @State private var name: String
    @State private var quantity: String
    @State private var date: String
    @State private var message = ""

    init(item: InventoryItem) {
        self.item = item
        _name = State(initialValue: item.name)
        _quantity = State(initialValue: String(item.quantity))
        _date = State(initialValue: item.date)
    }

    var body: some View {
        Form {
            TextField("Item Name", text: $name)
            TextField("Quantity", text: $quantity)
                .keyboardType(.numberPad)
            TextField("Date", text: $date)

            if !message.isEmpty {
                Text(message).foregroundColor(.red)
            }

            Button("Save Changes") {
                saveChanges()
            }

            Button("Delete Item", role: .destructive) {
                deleteItem()
            }
        }
        .navigationTitle("Edit Item")
    }

    private func saveChanges() {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            message = "Enter item name."
            return
        }

        guard let qty = Int(quantity), qty >= 0 else {
            message = "Enter a valid quantity."
            return
        }

        item.name = name.trimmingCharacters(in: .whitespaces)
        item.quantity = qty
        item.date = date.trimmingCharacters(in: .whitespaces)

        do {
            try modelContext.save()
            dismiss()
        } catch {
            message = "Update failed."
        }
    }

    private func deleteItem() {
        modelContext.delete(item)

        do {
            try modelContext.save()
            dismiss()
        } catch {
            message = "Delete failed."
        }
    }
}
