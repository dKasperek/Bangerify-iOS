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
            PostHeaderView(post: post, onPostDeleted: onPostDeleted, showingEditPostSheet: $showingEditPostSheet)
            
            PostContentView(post: post)
            
            PostFooterView(post: post, showAddCommentView: $showAddCommentView, toggleLike: toggleLike)
            
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

