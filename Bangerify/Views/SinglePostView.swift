//
//  SinglePostView.swift
//  Bangerify
//
//  Created by David Kasperek on 27/03/2023.
//

import SwiftUI

struct SinglePostView: View {
    var post: Post
    @ObservedObject var viewModel: PostViewModel
    
    public init(post: Post) {
        self.post = post
        self.viewModel = PostViewModel(post: post)
    }
    
    var body: some View {
        NavigationView {
            if let post = post {
                ScrollView {
                    VStack(alignment: .leading) {
                        Section {
                            PostView(post: post)
                        }
                    }
                    .padding(.horizontal)
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(10)
                    .shadow(radius: 1)
                    .padding(.vertical, 8)
                }
                .clipped()
                .padding(.horizontal)
                .background(Color(.systemGroupedBackground))
            } else {
                ProgressView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SinglePostView_Previews: PreviewProvider {
    static var post = Post(
        id: 138,
        text: "**Daily żarcik:**\n\nCo mówi młynarz widzący małpy w zoo?\n> dużo mąki",
        date: "2023-01-30T13:11:23.000Z",
        images: [URL(string: "https://bangerify-media.s3.eu-central-1.amazonaws.com/8543f960fd209be3389357a9e36e80f4")!],
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
