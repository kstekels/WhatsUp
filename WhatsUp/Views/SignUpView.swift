//
//  SignUpView.swift
//  WhatsUp
//
//  Created by Kārlis Štekels on 04/09/2023.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var displayName: String = ""
    @State private var errorMessage: String = ""
    
    @EnvironmentObject private var model: Model
    @EnvironmentObject private var appState: AppState
    
    private var isFormValid: Bool {
        !email.isEmptyOrWithWhiteSpace && !password.isEmptyOrWithWhiteSpace && !displayName.isEmptyOrWithWhiteSpace
    }
    
    private func signup() async {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            try  await model.updateDisplayName(for: result.user, displayName: displayName)
            appState.routes.append(.login)
        } catch {
            errorMessage = error.localizedDescription
            print(error)
        }
    }
    
    var body: some View {
        Form {
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
                .textInputAutocapitalization(.never)
            TextField("Display name", text: $displayName)
            
            HStack {
                
                Spacer()
                
                Button("SignUp") {
                    Task {
                        await signup()
                    }
                }
                .disabled(!isFormValid)
                Spacer()
                
                Button("Login") {
                    //TODO: Take user to login
                    appState.routes.append(.login)
                }.buttonStyle(.borderless)
                
                Spacer()
            }
            if (!errorMessage.isEmpty) {
                Text("Error: \(errorMessage)")
            }
            
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(Model())
            .environmentObject(AppState())
    }
}
