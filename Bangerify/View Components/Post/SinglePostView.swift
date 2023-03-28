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
    
    var post: Post
    @ObservedObject var viewModel: PostViewModel
    @State private var showAddCommentView = false
    
    public init(post: Post) {
        self.post = post
        self.viewModel = PostViewModel(post: post)
    }
    
    public var body: some View {
        VStack {
            PostHeaderComponent(post: post)
            
            NavigationLink(destination: DetailPostView(post: post)) {
                VStack {
                    MarkdownContentView(post: post)
                    
                    if let images = post.images, !images.isEmpty {
                        ImageViewComponent(post: post, images: images)
                    }
                }
            }.buttonStyle(PlainButtonStyle())
            
            
            HStack {
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
            if viewModel.comments != nil {
                CommentListView(comList: viewModel.comments!)
                    .padding(.bottom, 5)
            }
        }
        .padding(5)
        .padding(.top, 10)
        .onReceive(viewModel.$post) { _ in
            viewModel.loadData()
        }
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
}

struct PostView_Previews: PreviewProvider {
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
        SinglePostView(post: post)
    }
}
