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
    
    var isOwner: Bool
    @State private var profile: Profile?
    @State private var posts: [Post]?
    
    init(username: String) {
        self.username = username
        self.isOwner = (self.username == AuthenticationService.shared.getUsername())
    }

    
    var body: some View {
        NavigationView {
            if let profile = profile, let posts = posts {
                ScrollView {
                    HStack {
                        KFImage(URL(string: profile.profilePictureUrl ?? ""))
                            .placeholder {
                                Image(systemName: "hourglass")
                                    .foregroundColor(.gray)
                            }
                            .cancelOnDisappear(true)
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 75, height: 75)
                        
                        VStack (alignment: .leading){
                            HStack {
                                Text(profile.visibleName)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(getGradeColor(grade: profile.grade))
                                Spacer()
                                if isOwner {
                                    Image(systemName: "ellipsis")
                                        .font(Font.system(.body))
                                        .foregroundColor(.secondary)
                                }
                            }
                            HStack {
                                Text("@" + username)
                                    .font(.headline)
                                    .fontWeight(.light)
                                
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        }
                    } .padding(5)
                    
                    Markdown(profile.bio ?? "")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                    
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
