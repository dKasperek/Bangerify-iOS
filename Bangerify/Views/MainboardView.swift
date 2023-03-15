//
//  ContentView.swift
//  Bangerify
//
//  Created by David Kasperek on 25/01/2023.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    @ObservedObject var postService = PostService()

    var body: some View {
        NavigationView {
            if let posts = postService.posts {
                ScrollView {
                    LazyVStack {
                        ForEach(posts, id: \.id) { post in
                            VStack(alignment: .leading) {
                                let commentCount = 0 // Replace with actual comment count when available
                                Section() {
                                    PostView(post: post, commentCount: commentCount)
                                    // Uncomment when you want to show comments
                                    // if commentCount != 0 {
                                    //     CommentView(post: post)
                                    // }
                                }
                            }
                            .padding(.horizontal)
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .shadow(radius: 1)
                            .padding(.vertical, 8)
                        }
                    }
                }
                .padding(.horizontal)
                .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.bottom))
                .navigationTitle("Mainboard")
                .refreshable {
                    postService.loadPosts(completion: { [weak postService] posts in
                        postService?.posts = posts
                    })
                }
            } else {
                ProgressView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
