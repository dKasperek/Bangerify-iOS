//
//  TabBarView.swift
//  Bangerify
//
//  Created by David Kasperek on 01/04/2023.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab = 1
    @ObservedObject var postService = PostService()
    
    private func onSwipeEnded(drag: DragGesture.Value) {
        let swipeThreshold: CGFloat = 50
        if drag.predictedEndTranslation.width > swipeThreshold {
            selectedTab = max(selectedTab - 1, 0)
        } else if drag.predictedEndTranslation.width < -swipeThreshold {
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
            
            MainboardView(postService: postService)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Mainboard")
                }
                .tag(1)
                .onAppear {
                    postService.loadPosts(completion: { [weak postService] posts in
                        postService?.posts = posts
                    })
                }
            
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
