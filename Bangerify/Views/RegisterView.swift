//
//  RegisterView.swift
//  Bangerify
//
//  Created by David Kasperek on 17/03/2023.
//

import SwiftUI

struct RegisterView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var showEmailNotification: Bool = false
    @State private var errorMessage: String? = nil
    @StateObject private var authService = AuthenticationService()
    @EnvironmentObject var authenticationService: AuthenticationService
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer().frame(height: 30)
                    
                    Text("Register to BANGERIFY")
                        .headerTitleStyle()
                    
                    Spacer().frame(height: 20)
                    
                    TextField("Username", text: $username)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .textContentType(.username)
                    
                    TextField("Email", text: $email)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .textContentType(.emailAddress)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.newPassword)
                    
                    Spacer().frame(height: 20)
                    
                    Button("Register") {
                        if username.isEmpty || email.isEmpty || password.isEmpty {
                            errorMessage = "Username, email, or password field is empty!"
                            showAlert = true
                        } else {
                            authService.register(username: username, email: email, password: password) { result in
                                switch result {
                                case .success(let response):
                                    print("Registration response: \(response.message)")
                                    if response.message == "account created" {
                                        showEmailNotification = true
                                        presentationMode.wrappedValue.dismiss()
                                    } else if response.message == "username or email exist" {
                                        errorMessage = "Username or email already exists."
                                        showAlert = true
                                    } else {
                                        errorMessage = "Registration failed."
                                        showAlert = true
                                    }
                                    
                                case .failure(let error):
                                    print("Registration failed: \(error.localizedDescription)")
                                    errorMessage = error.localizedDescription
                                    showAlert = true
                                }
                            }
                        }
                    }
                    .sentButtonStyle()
                    
                    Spacer().frame(height: 20)
                    
                }
                .cardboardStyle()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal)
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $showEmailNotification) {
                Alert(title: Text("Account created"), message: Text(errorMessage ?? "Please verify your email!"), dismissButton: .default(Text("OK")))
            }
        }
    }
    
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
