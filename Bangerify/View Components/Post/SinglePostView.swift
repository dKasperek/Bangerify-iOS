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
    
    @State var post: Post
    @ObservedObject var viewModel: PostViewModel
    @EnvironmentObject var authenticationService: AuthenticationService
    var username = AuthenticationService.shared.getUsername()
    @State private var showAddCommentView = false
    @State private var showingEditPostView = false
    
    let onPostDeleted: () -> Void
    
    public init(post: Post, onPostDeleted: @escaping () -> Void) {
        self.post = post
        self.viewModel = PostViewModel(post: post)
        self.onPostDeleted = onPostDeleted
    }
    
    public var body: some View {
        VStack {
            // Post header
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
                        
                        if post.username == AuthenticationService.shared.getUsername() {
                            Menu {
                                Button(action: {
                                    showingEditPostView = true
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
                    EditPostView(post: post, onPostEdited: { text in
                        self.post.text = text
                        self.viewModel.post.text = text
                    })
                }
            
            // Post content
            
            NavigationLink(destination: DetailPostView(post: post)) {
                VStack {
                    MarkdownContentView(post: post)
                    
                    if let images = post.images, !images.isEmpty {
                        ImageViewComponent(post: post, images: images)
                    }
                }
            }.buttonStyle(PlainButtonStyle())
            
            HStack {
                // Post footer
                Button(action: toggleLike) {
                    if (viewModel.liked == 1) {
                        Image(systemName: "heart.fill")
                            .font(Font.system(.title3))
                            .foregroundColor(.red)
                    } else {
                        Image(systemName: "heart")
                            .font(Font.system(.title3))
                            .foregroundColor(.primary)
                    }
                }
                Text(String(viewModel.likes))
                    .font(Font.system(.title3))
                
                Spacer()
                
                Text(String(viewModel.comments?.count ?? 0)).font(Font.system(.title3))
                    .foregroundColor(.primary)
                Button(action: {
                    showAddCommentView.toggle()
                }) {
                    if (viewModel.comments?.isEmpty == false) {
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
                    AddCommentView(viewModel: viewModel)
                }
                
            } .frame(maxWidth: .infinity, alignment: .leading)
                .padding(5)
            
            // Post Comments
            if viewModel.comments != nil {
                CommentListView(comList: viewModel.comments!)
                    .padding(.bottom, 5)
            }
        }
        .padding(5)
        .padding(.top, 10)
        .onReceive(authenticationService.$isAuthenticated, perform: { isAuthenticated in
            if isAuthenticated {
                viewModel.loadData()
            }
        })
    }
    
    func toggleLike() {
        LikeService.shared.setLike(for: post.id) {
            if viewModel.liked == 1 {
                viewModel.liked = 0
                viewModel.likes -= 1
            } else {
                viewModel.liked = 1
                viewModel.likes += 1
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
    static var post = Post(
        id: 138,
        text: "**Daily żarcik:**\n\nCo mówi młynarz widzący małpy w zoo?\n> dużo mąki",
        date: "2023-01-30T13:11:23.000Z",
        images: [URL(string: "https://bangerify-media.s3.eu-central-1.amazonaws.com/8543f960fd209be3389357a9e36e80f4")!, URL(string: "https://bangerify-media.s3.eu-central-1.amazonaws.com/8543f960fd209be3389357a9e36e80f4")!],
        userId: 5,
        username: "wojciehc",
        visibleName: "wojciech",
        profilePictureUrl: "https://f4.bcbits.com/img/a0340908479_7.jpg",
        likes: 3,
        liked: 1,
        grade: 4
    )
    
    static var previews: some View {
        let authenticationService = AuthenticationService()
        return SinglePostView(post: post, onPostDeleted: {})
            .environmentObject(authenticationService)
    }
}

