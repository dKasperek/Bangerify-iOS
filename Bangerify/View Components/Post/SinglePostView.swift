//
//  SinglePostView.swift
//  Bangerify
//
//  Created by David Kasperek on 28/01/2023.
//

import Foundation
import SwiftUI
import MarkdownUI
import Kingfisher
import Combine

public struct SinglePostView: View {
    
    @StateObject var post: PostObject
    @EnvironmentObject var authenticationService: AuthenticationService
    var username = AuthenticationService.shared.getUsername()
    @State private var showAddCommentView = false
    @State private var showingEditPostSheet = false
    
    let onPostDeleted: () -> Void
    
    public init(post: PostObject, onPostDeleted: @escaping () -> Void) {
        _post = StateObject(wrappedValue: post)
        self.onPostDeleted = onPostDeleted
    }
    
    public var body: some View {
        VStack {
            // Post header
            postHeader
            
            // Post content
            
            NavigationLink(destination: DetailPostView(post: post)) {
                VStack {
                    MarkdownContentView(post: post)
                        .environmentObject(post)
                    
                    if let images = post.images, !images.isEmpty {
                        ImageViewComponent(post: post, images: images)
                    }
                }
            }.buttonStyle(PlainButtonStyle())
            
            // Post footer
            postFooter
            
            // Post Comments
            if post.comments != nil {
                CommentListView(comList: post.comments!)
                    .padding(.bottom, 5)
            }
        }
        .padding(5)
        .padding(.top, 10)
        .onAppear {
            if post.likes == nil {
                post.updateLikes()
            }
            if post.comments == nil {
                post.updateComments()
            }
        }
    }
}

private extension SinglePostView {
    var postHeader: some View {
        HStack {
            NavigationLink(destination: ProfileView(username: post.username)) {
                if let url = URL(string: post.profilePictureUrl ) {
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
                    
                    if post.username == AuthenticationService.shared.getUsername() {
                        Menu {
                            Button(action: {
                                showingEditPostSheet = true
                            }) {
                                Label("Edit post", systemImage: "pencil")
                            }
                            Button(role: .destructive, action: {
                                deletePost {
                                    onPostDeleted()
                                }
                            }) {
                                Label("Delete post", systemImage: "trash")
                                    .foregroundColor(.red)
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        .sheet(isPresented: $showingEditPostSheet) {
                            EditPostSheet(post: post)
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
    }
    
    var postFooter: some View {
        HStack {
            // Post footer
            Button(action: toggleLike) {
                if (post.liked == 1) {
                    Image(systemName: "heart.fill")
                        .font(Font.system(.title3))
                        .foregroundColor(.red)
                } else {
                    Image(systemName: "heart")
                        .font(Font.system(.title3))
                        .foregroundColor(.primary)
                }
            }
            Text(String(post.likes ?? 0))
                .font(Font.system(.title3))
            
            Spacer()
            
            Text(String(post.comments?.count ?? 0)).font(Font.system(.title3))
                .foregroundColor(.primary)
            Button(action: {
                showAddCommentView.toggle()
            }) {
                if (post.comments?.isEmpty == false) {
                    Image(systemName: "bubble.left.fill")
                        .font(Font.system(.title3))
                        .foregroundColor(Color(.systemBlue))
                } else {
                    Image(systemName: "bubble.left")
                        .font(Font.system(.title3))
                        .foregroundColor(.primary)
                }
            }
            .sheet(isPresented: $showAddCommentView) {
                AddCommentView(postObject: post)
            }
            
        } .frame(maxWidth: .infinity, alignment: .leading)
            .padding(5)
    }
}

private extension SinglePostView {
    func toggleLike() {
        LikeService.shared.setLike(for: post.id) {
            if post.liked == 1 {
                post.liked = 0
                post.likes = (post.likes ?? 0) - 1
            } else {
                post.liked = 1
                post.likes = (post.likes ?? 0) + 1
            }
        }
    }
    
    
    func deletePost(completion: @escaping () -> Void) {
        PostService.shared.deletePost(postId: post.id) { result in
            switch result {
            case .success:
                print("Post deleted successfully")
                completion()
            case .failure(let error):
                print("Error deleting post: \(error)")
            }
        }
    }
}

struct SinglePostView_Previews: PreviewProvider {
    static var post = PostObject(
        id: 138,
        text: "**Daily żarcik:**\n\nCo mówi młynarz widzący małpy w zoo?\n> dużo mąki",
        date: "2023-01-30T13:11:23.000Z",
        images: [URL(string: "https://bangerify-media.s3.eu-central-1.amazonaws.com/8543f960fd209be3389357a9e36e80f4")!, URL(string: "https://bangerify-media.s3.eu-central-1.amazonaws.com/8543f960fd209be3389357a9e36e80f4")!],
        userId: 5,
        username: "wojciehc",
        visibleName: "wojciech",
        profilePictureUrl: "https://f4.bcbits.com/img/a0340908479_7.jpg",
        grade: 4,
        likes: 3,
        liked: 1
    )
    
    
    static var previews: some View {
        let authenticationService = AuthenticationService()
        return SinglePostView(post: post, onPostDeleted: {})
            .environmentObject(authenticationService)
    }
}

