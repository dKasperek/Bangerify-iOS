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
                    VStack {
                        Spacer().frame(height: 20)
                        HStack {
                            KFImage(URL(string: profile.profilePictureUrl ?? ""))
                                .placeholder {
                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .foregroundColor(.gray)
                                        .frame(width: 75, height: 75)
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
                                        Menu {
                                            Button(action: {
                                                // Edut visible name
                                            }) {
                                                Label("Edit visible name", systemImage: "pencil.line")
                                            }
                                            
                                            Button(action: {
                                                // Edit profile picture
                                            }) {
                                                Label("Change profile picture", systemImage: "camera")
                                            }
                                            
                                            Button(action: {
                                                // Edit bio text
                                            }) {
                                                Label("Change BIO", systemImage: "square.and.pencil")
                                            }
                                            
                                            
                                        } label: {
                                            Image(systemName: "ellipsis.circle")
                                                .font(Font.system(.body))
                                                .foregroundColor(.primary)
                                        }
                                    }
                                }
                                HStack {
                                    Text("@" + username)
                                        .font(.headline)
                                        .fontWeight(.light)
                                    
                                }.frame(maxWidth: .infinity, alignment: .leading)
                            }
                        } .padding(5)
                    }
                    
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
