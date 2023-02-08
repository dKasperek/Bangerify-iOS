//
//  ProfileView.swift
//  Bangerify
//
//  Created by David Kasperek on 29/01/2023.
//

import SwiftUI
import MarkdownUI
import Kingfisher
import Network


struct ProfileView: View {
    let username: String
    
    @State private var profile: Profile?
    @State private var posts: [Post]?
    
    
    var body: some View {
        List {
            if let profile = profile, let posts = posts {
                
                ProfileHeaderComponent(profile: profile, username: username)
                                
                ForEach(posts, id: \.id) { post in
                    Section{
                        PostView(post: post, commentCount: 0)
                    }
                }
                
            } else {
                ProgressView()
            }
        }
        .onAppear {
            self.loadProfile()
        }
        .refreshable {
            self.loadProfile()
        }
    }
    
    private func loadProfile() {
        let profileService = ProfileService()
        profileService.loadProfile(username: self.username) { profile in
            self.profile = profile
        }
            
        let postService = PostService()
        postService.loadUserPosts(author: self.username) { posts in
        self.posts = posts
        }
    }
    
    
    
    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileView(username: "wojciehc")
        }
    }

}
