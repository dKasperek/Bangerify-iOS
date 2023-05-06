//
//  MainboardView.swift
//  Bangerify
//
//  Created by David Kasperek on 25/01/2023.
//

import SwiftUI
import Kingfisher

struct MainboardView: View {
    @State private var showAddPostView = false
    @EnvironmentObject var postService: PostService
    @EnvironmentObject var authenticationService: AuthenticationService
    @State private var fetchMorePosts = false
    
    var body: some View {
        NavigationView {
            if let posts = postService.posts {
                ScrollView {
                    LazyVStack {
                        AddPostButtonView(showAddPostView: $showAddPostView)
                        
                        ForEach(posts, id: \.id) { post in
                            VStack(alignment: .leading) {
                                SinglePostView(post: post, onPostDeleted: {
                                    if let index = postService.posts?.firstIndex(where: { $0.id == post.id }) {
                                        postService.posts?.remove(at: index)
                                    }
                                })
                            }
                            .cardboardStyle()
                            .onAppear {
                                if post == posts.last {
                                    loadMorePosts()
                                }
                            }
                        }
                        
                        if fetchMorePosts {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding(.top, 10)
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
                LoadingPlaceholderView()
            }
        }
    }
    
    private func loadMorePosts() {
        guard !fetchMorePosts, let posts = postService.posts, let lastPostId = posts.last?.id else { return }
        
        fetchMorePosts = true
        
        postService.loadPosts(lastPostId: lastPostId) { newPosts in
            Task {
                if let newPosts = newPosts {
                    self.postService.posts?.append(contentsOf: newPosts)
                }
                self.fetchMorePosts = false
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let authenticationService = AuthenticationService()
        let postService = PostService()
        return MainboardView()
            .environmentObject(authenticationService)
            .environmentObject(postService)
    }
}
