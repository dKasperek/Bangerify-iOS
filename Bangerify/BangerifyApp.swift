//
//  BangerifyApp.swift
//  Bangerify
//
//  Created by David Kasperek on 25/01/2023.
//

import SwiftUI

@main
struct BangerifyApp: App {
    @StateObject private var authenticationService = AuthenticationService()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authenticationService.isAuthenticated {
                    MainboardView()
                } else {
                    LoginRegisterView()
                }
            }
            .environmentObject(authenticationService)
        }
    }
}
