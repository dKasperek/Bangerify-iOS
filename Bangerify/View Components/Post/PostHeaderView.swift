//
//  PostHeaderView.swift
//  Bangerify
//
//  Created by David Kasperek on 07/05/2023.
//

import SwiftUI
import Kingfisher

struct PostHeaderView: View {
    @ObservedObject var post: PostObject
    let onPostDeleted: () -> Void
    @Binding var showingEditPostSheet: Bool
    
    var body: some View {
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

struct PostHeaderView_Previews: PreviewProvider {
    @State static var showingEditPostSheet = false
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
        PostHeaderView(
            post: post,
            onPostDeleted: {},
            showingEditPostSheet: $showingEditPostSheet
        )
    }
}

