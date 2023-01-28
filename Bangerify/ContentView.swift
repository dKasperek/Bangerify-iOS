//
//  ContentView.swift
//  Bangerify
//
//  Created by David Kasperek on 25/01/2023.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    @EnvironmentObject var network: Network
    
    var body: some View {
        NavigationStack {
            List(network.posts) { post in
                let commentCount = network.getCommentCount(postId: post.id)
                Section(){
                    PostView(post: post, commentCount: commentCount)
                    if commentCount != 0 {
                        CommentView(post: post)
                    }
                }
            }
            
            .navigationTitle("Bangerify")
            
            .onAppear{
                network.getPosts()
            }
            .refreshable {
                network.getPosts()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Network())
    }
}
