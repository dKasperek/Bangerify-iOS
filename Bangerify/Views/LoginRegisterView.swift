//
//  LoginRegisterView.swift
//  Bangerify
//
//  Created by David Kasperek on 16/03/2023.
//

import SwiftUI

struct LoginRegisterView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var errorMessage: String? = nil
    @StateObject private var authService = AuthenticationService()
    @EnvironmentObject var authenticationService: AuthenticationService
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250)
                        .padding(.bottom, 20)
                        .padding(.top, 25)
                    
                    TextField("Username or Email", text: $email)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .textContentType(.emailAddress)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.password)
                    
                    Spacer().frame(height: 20)
                    
                    Button("Login") {
                        if email.isEmpty || password.isEmpty {
                            errorMessage = "Email or password field is empty!"
                            showAlert = true
                        } else {
                            authService.login(username: email, password: password) { result in
                                switch result {
                                case .success(_):
                                    authenticationService.isAuthenticated = true
                                    
                                case .failure(let error):
                                    print("Login failed: \(error.localizedDescription)")
                                    errorMessage = error.localizedDescription
                                    showAlert = true
                                }
                            }
                        }
                    }
                    .sentButtonStyle()
                    
                    Spacer().frame(height: 20)
                    
                    NavigationLink(destination: RegisterView()) {
                        Text("Register instead")
                            .cancelButtonStyle()
                    }
                    
                    Spacer().frame(height: 20)
                }
                .cardboardStyle()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .backgroundStyle()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
            }
        }
    }
    
}

struct LoginRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        LoginRegisterView()
    }
}
