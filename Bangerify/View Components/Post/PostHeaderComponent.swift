//
//  PostHeaderComponent.swift
//  Bangerify
//
//  Created by David Kasperek on 28/03/2023.
//

import SwiftUI
import Kingfisher

struct PostHeaderComponent: View {
    var post: Post
    var username = AuthenticationService.shared.getUsername()
    @State private var showingEditPostView = false
    
    var body: some View {
        HStack {
            NavigationLink(destination: ProfileView(username: post.username)) {
                if let url = URL(string: post.profilePictureUrl ?? "") {
                    KFImage(url)
                        .placeholder {
                            Image(systemName: "hourglass")
                                .foregroundColor(.gray)
                        }
                        .cancelOnDisappear(true)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack (alignment: .leading){
                HStack {
                    NavigationLink(destination: ProfileView(username: post.username)) {
                        Text(post.visible_name)
                            .font(.headline)
                            .foregroundColor(getGradeColor(grade: post.grade))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    if post.username == username {
                        Menu {
                            Button(action: {
                                showingEditPostView = true
                            }) {
                                Label("Edit post", systemImage: "pencil")
                            }
                            Button(role: .destructive, action: {
                                // Add action for deleting post
                            }) {
                                Label("Delete post", systemImage: "trash")
                                    .foregroundColor(.red)
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                HStack {
                    NavigationLink(destination: ProfileView(username: post.username)) {
                        Text("@" + post.username)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    Text(formatDate(dateString: post.date))
                        .font(.caption)
                        .fontWeight(.light)
                        .foregroundColor(.secondary)
                    
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
        } .padding(5)
            .sheet(isPresented: $showingEditPostView) {
                        EditPostView(post: post, onPostEdited: {
                            // You can add any additional actions here when the post is edited
                        })
                    }
    }
}
