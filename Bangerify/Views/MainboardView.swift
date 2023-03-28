//
//  ContentView.swift
//  Bangerify
//
//  Created by David Kasperek on 25/01/2023.
//

import SwiftUI
import Kingfisher

struct MainboardView: View {
    @ObservedObject var postService = PostService()
    @EnvironmentObject var authenticationService: AuthenticationService
    
    var body: some View {
        NavigationView {
            if let posts = postService.posts {
                ScrollView {
                    LazyVStack {
                        ForEach(posts, id: \.id) { post in
                            VStack(alignment: .leading) {
                                Section() {
                                    SinglePostView(post: post)
                                }
                            }
                            .padding(.horizontal)
                            .background(Color(.secondarySystemGroupedBackground))
                            .cornerRadius(10)
                            .shadow(radius: 1)
                            .padding(.vertical, 8)
                        }
                    }
                }
                .padding(.horizontal)
                .background(Color(.systemGroupedBackground))
                .navigationTitle("Mainboard")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Logout") {
                            authenticationService.clearToken()
                        }
                    }
                }
                .refreshable {
                    postService.loadPosts(completion: { [weak postService] posts in
                        postService?.posts = posts
                    })
                }
            } else {
                VStack {
                    Image("icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .padding(.bottom, 25)
                    ProgressView()}
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainboardView()
    }
}
