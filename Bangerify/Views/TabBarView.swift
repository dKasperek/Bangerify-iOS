//
//  TabBarView.swift
//  Bangerify
//
//  Created by David Kasperek on 01/04/2023.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab = 1
    
    private func onSwipeEnded(drag: DragGesture.Value) {
        let swipeThreshold: CGFloat = 50
        if drag.predictedEndTranslation.width > swipeThreshold {
            // Swipe right detected
            selectedTab = max(selectedTab - 1, 0)
        } else if drag.predictedEndTranslation.width < -swipeThreshold {
            // Swipe left detected
            selectedTab = min(selectedTab + 1, 2)
        }
    }
    
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
        .gesture(DragGesture()
             .onEnded(onSwipeEnded(drag:))
         )
        .animation(.easeOut(duration: 0.2), value: selectedTab)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
