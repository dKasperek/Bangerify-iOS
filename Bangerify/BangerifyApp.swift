//
//  BangerifyApp.swift
//  Bangerify
//
//  Created by David Kasperek on 25/01/2023.
//

import SwiftUI

@main
struct BangerifyApp: App {
    var network = Network()
    
    var body: some Scene {
        WindowGroup {
            LoginRegisterView()
                .environmentObject(network)
        }
    }
}
