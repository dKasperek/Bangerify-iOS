//
//  PostContentView.swift
//  Bangerify
//
//  Created by David Kasperek on 07/05/2023.
//

import SwiftUI

struct PostContentView: View {
    @ObservedObject var post: PostObject
    
    var body: some View {
        VStack {
            NavigationLink(destination: DetailPostView(post: post)) {
                MarkdownContentView(post: post)
                    .environmentObject(post)
            }.buttonStyle(PlainButtonStyle())
            
            if let images = post.images, !images.isEmpty {
                ImageViewComponent(post: post, images: images)
            }
        }
    }
}

struct PostContentView_Previews: PreviewProvider {
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
        PostContentView(post: post)
    }
}
