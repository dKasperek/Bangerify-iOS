//
//  PostFooterView.swift
//  Bangerify
//
//  Created by David Kasperek on 07/05/2023.
//

import SwiftUI

struct PostFooterView: View {
    @ObservedObject var post: PostObject
    @Binding var showAddCommentView: Bool
    var toggleLike: () -> Void
    
    var body: some View {
        HStack {
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

struct PostFooterView_Previews: PreviewProvider {
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
    
    @State static var showAddCommentView = false
    
    static var previews: some View {
        PostFooterView(post: post, showAddCommentView: $showAddCommentView, toggleLike: {})
    }
}
