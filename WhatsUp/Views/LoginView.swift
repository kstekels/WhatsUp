//
//  LoginView.swift
//  WhatsUp
//
//  Created by Kārlis Štekels on 04/09/2023.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    
    @EnvironmentObject private var appState: AppState
    
    private var isFormValid: Bool {
        !email.isEmptyOrWithWhiteSpace && !password.isEmptyOrWithWhiteSpace
    }
    
    private func login() async {
        do {
            let _ = try await Auth.auth().signIn(withEmail: email, password: password)
            //TODO: Go to main screen
            appState.routes.append(.main)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    var body: some View {
        Form {
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
                .textInputAutocapitalization(.never)
            
            HStack {
                Spacer()
                
                Button("Login") {
                    Task {
                        await login()
                    }
                    
                }
                .buttonStyle(.borderless)
                .disabled(!isFormValid)
                
                Spacer()
                
                
                Button("SignUp") {
                    Task {
                        //TODO: Go to Registration
                        appState.routes.append(.signup)
                    }
                }
                Spacer()
            }
            if (!errorMessage.isEmpty) {
                Text("Error: \(errorMessage)")
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AppState())
    }
}
