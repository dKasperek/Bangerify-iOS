//
//  DetailPostView.swift
//  Bangerify
//
//  Created by David Kasperek on 27/03/2023.
//

import SwiftUI

struct DetailPostView: View {
    var post: Post
    @ObservedObject var viewModel: PostViewModel
    @State private var showAddCommentView = false
    @Environment(\.presentationMode) var presentationMode
    
    
    public init(post: Post) {
        self.post = post
        self.viewModel = PostViewModel(post: post)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Section {
                    SinglePostView(post: post, onPostDeleted: {
                        presentationMode.wrappedValue.dismiss()
                    })
                }
            }
            .cardboardStyle()
            
            Button(action: {
                showAddCommentView.toggle()
            }) {
                Text("Add comment")
                    .cancelButtonStyle()
            }
            .sheet(isPresented: $showAddCommentView) {
                AddCommentView(viewModel: viewModel)
            }
            
        }
        .clipped()
        .backgroundStyle()
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailPostView_Previews: PreviewProvider {
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
        let authenticationService = AuthenticationService()
        return DetailPostView(post: post)
            .environmentObject(authenticationService)
    }
}
