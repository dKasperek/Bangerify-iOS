//
//  TabBarView.swift
//  Bangerify
//
//  Created by David Kasperek on 01/04/2023.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            AddPostView {
                DispatchQueue.main.async {
                    selectedTab = 1
                }
            }
            .tabItem {
                Image(systemName: "square.and.pencil")
                Text("New Post")
            }
            .tag(0)
            
            MainboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Mainboard")
                }
                .tag(1)
            
            ProfileView(username: AuthenticationService.shared.getUsername() ?? "")
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(2)
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
