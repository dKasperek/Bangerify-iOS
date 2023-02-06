//
//  ContentView.swift
//  Bangerify
//
//  Created by David Kasperek on 25/01/2023.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    @State private var posts: [Post]?
    
    var body: some View {
        NavigationView {
            if let posts = posts {
                List(posts) { post in
//                    let commentCount = network.getCommentCount(postId: post.id)
                    let commentCount = 0
                    Section(){
                        PostView(post: post, commentCount: commentCount)
//                        if commentCount != 0 {
//                            CommentView(post: post)
//                        }
                    }
                }
            } else {
                ProgressView()
            }
        }
        .navigationTitle("Mainboard")
        
        .onAppear{
            self.loadPosts()
        }
        .refreshable {
            self.loadPosts()
        }
    }
    
    private func loadPosts() {
        let postService = PostService()
        postService.loadPosts() { posts in
            self.posts = posts
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
