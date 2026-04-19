//
//  LoginView.swift
//  InventoryManager
//
//  Created by Christopher O'Dell on 3/22/26.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var auth: AuthManager

    @State private var email = ""
    @State private var password = ""
    @State private var message = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Inventory App")
                    .font(.largeTitle)
                    .bold()

                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textFieldStyle(.roundedBorder)

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)

                Button("Log In") {
                    login()
                }
                .buttonStyle(.borderedProminent)

                Button("Register") {
                    register()
                }
                .buttonStyle(.bordered)

                if !message.isEmpty {
                    Text(message)
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
    }

    private func validEmail(_ value: String) -> Bool {
        value.contains("@") && value.contains(".")
    }

    private func login() {
        guard !email.isEmpty, !password.isEmpty else {
            message = "Enter email and password."
            return
        }

        guard validEmail(email) else {
            message = "Enter a valid email."
            return
        }

        do {
            let success = try auth.loginUser(email: email, password: password, context: modelContext)
            message = success ? "" : "Invalid login."
        } catch {
            message = "Login error."
        }
    }

    private func register() {
        guard !email.isEmpty, !password.isEmpty else {
            message = "Enter email and password."
            return
        }

        guard validEmail(email) else {
            message = "Enter a valid email."
            return
        }

        do {
            let success = try auth.registerUser(email: email, password: password, context: modelContext)
            message = success ? "" : "User already exists."
        } catch {
            message = "Registration error."
        }
    }
}
