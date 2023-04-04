//
//  ContentView.swift
//  Bangerify
//
//  Created by David Kasperek on 25/01/2023.
//

import SwiftUI
import Kingfisher

struct MainboardView: View {
    @State private var showAddPostView = false
    @ObservedObject var postService = PostService()
    @EnvironmentObject var authenticationService: AuthenticationService
    
    var body: some View {
        NavigationView {
            if let posts = postService.posts {
                ScrollView {
                    LazyVStack {
                        HStack {
                            Button(action: {
                                showAddPostView.toggle()
                            }) {
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(.primary)
                                Text("Add a new post...")
                                
                            }
                            .sheet(isPresented: $showAddPostView) {
                                AddPostSheet {
                                    postService.loadPosts(completion: { [weak postService] posts in
                                        postService?.posts = posts
                                    })
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(5)
                        .padding(.vertical, 10)
                        .cardboardStyle()
                        
                        ForEach(posts, id: \.id) { post in
                            VStack(alignment: .leading) {
                                Section() {
                                    SinglePostView(post: post, onPostDeleted: {
                                        if let index = postService.posts?.firstIndex(where: { $0.id == post.id }) {
                                            postService.posts?.remove(at: index)
                                        }
                                    })
                                }
                            }
                            .cardboardStyle()
                        }
                        
                    }
                }
                .backgroundStyle()
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
        let authenticationService = AuthenticationService()
        return MainboardView(postService: PostService())
            .environmentObject(authenticationService)
    }
}
