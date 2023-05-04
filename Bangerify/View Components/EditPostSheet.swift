//
//  EditPostView.swift
//  Bangerify
//
//  Created by David Kasperek on 28/03/2023.
//

import SwiftUI

struct EditPostSheet: View {
    @ObservedObject var post: PostObject
    @State private var postContent: String = ""
    @State private var showAlert: Bool = false
    @State private var errorMessage: String? = nil
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            Spacer().frame(height: 10)
            
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                        .cancelButtonStyle()
                })
                
                Spacer()
            }
            
            Spacer().frame(height: 50)
            
            Text("Edit a POST")
                .headerTitleStyle()
            
            Spacer().frame(height: 30)
            
            TextField("What's up?", text: $postContent, axis: .vertical)
                .padding()
                .lineLimit(5...8)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onAppear {
                    postContent = post.text
                }
            
            Text("* you can use markdown to format text")
                .font(.caption)
            
            Spacer().frame(height: 30)
            
            Button("SAVE changes") {
                if postContent.isEmpty {
                    errorMessage = "The content of the post can't be empty!"
                    showAlert = true
                } else {
                    PostService.shared.editPost(postId: post.id, newText: postContent) { result in
                        switch result {
                        case .success:
                            DispatchQueue.main.async {
                                post.text = postContent
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        case .failure(let error):
                            errorMessage = error.localizedDescription
                            showAlert = true
                        }
                    }
                }
            }
            .sentButtonStyle()
            
            Spacer()
            
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
        }
    }
}

struct EditPostView_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostObject(
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
        
        EditPostSheet(post: post)
            .sheet(isPresented: .constant(true)) {
                EditPostSheet(post: post)
            }
    }
}

