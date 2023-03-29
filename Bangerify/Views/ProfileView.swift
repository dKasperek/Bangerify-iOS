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
        NavigationView {
            if let profile = profile, let posts = posts {
                ScrollView {
                    ProfileHeaderComponent(profile: profile, username: username)
                    
                    LazyVStack {
                        ForEach(posts, id: \.id) { post in
                            VStack(alignment: .leading) {
                                Section {
                                    SinglePostView(post: post, onPostDeleted: {
                                        if let index = self.posts?.firstIndex(where: { $0.id == post.id }) {
                                            self.posts?.remove(at: index)
                                        }
                                    })                                }
                            }
                            .cardboardStyle()
                        }
                    }
                }
                .clipped()
                .backgroundStyle()
                
            } else {
                ProgressView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            self.loadProfile()
        }
        .refreshable {
            self.loadProfile()
        }
    }
    
    private func loadProfile() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        ProfileService.shared.loadProfile(username: self.username) { profile in
            self.profile = profile
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        PostService.shared.loadUserPosts(author: self.username) { posts in
            self.posts = posts
            dispatchGroup.leave()
        }
    }
    
    
    
    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileView(username: "wojciehc")
        }
    }
    
}
