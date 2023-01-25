//
//  ContentView.swift
//  Bangerify
//
//  Created by David Kasperek on 25/01/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var network: Network
    var body: some View {
        NavigationView {
            List {
                Text("Hello, world!")
            }
            .navigationTitle("Bangerify")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Network())
    }
}
