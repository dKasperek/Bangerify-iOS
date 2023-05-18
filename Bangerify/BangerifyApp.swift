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
    @StateObject private var postService = PostService()
    
//    init() {
//        authenticationService.clearToken()
//    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authenticationService.isAuthenticated {
                    MainboardView()
                        .environmentObject(postService)// TODO: TabBarView
                } else {
                    LoginRegisterView()
                }
            }
            .environmentObject(authenticationService)
            .onOpenURL{url in
                print("Launching main view from deep link")
            }
        }
    }
}
