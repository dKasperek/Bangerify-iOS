//
//  AddCommentView.swift
//  Bangerify
//
//  Created by David Kasperek on 27/03/2023.
//

import SwiftUI

struct AddCommentView: View {
    var postObject: PostObject
    @State private var commentContent: String = ""
    @State private var showAlert: Bool = false
    @State private var errorMessage: String? = nil
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
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
                
                Text("Add a COMMENT")
                    .headerTitleStyle()
                
                Spacer().frame(height: 30)
                
                TextField("Write a comment...", text: $commentContent, axis: .vertical)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Spacer().frame(height: 30)
                
                Button("Sent") {
                    if commentContent.isEmpty {
                        errorMessage = "The content of the comment can't be empty!"
                        showAlert = true
                    } else {
                        CommentService.shared.sendComment(postId: postObject.id, text: commentContent) { result in
                            switch result {
                            case .success:
                                DispatchQueue.main.async {
                                    postObject.updateComments()
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
    
}

struct AddCommentView_Previews: PreviewProvider {
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
        
        AddCommentView(postObject: post)
            .sheet(isPresented: .constant(true)) {
                AddCommentView(postObject: post)
            }
    }
}

