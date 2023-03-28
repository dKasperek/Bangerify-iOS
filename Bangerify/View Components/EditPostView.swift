//
//  EditPostView.swift
//  Bangerify
//
//  Created by David Kasperek on 28/03/2023.
//

import SwiftUI

struct EditPostView: View {
    var post: Post
    @State private var postContent: String = ""
    @State private var showAlert: Bool = false
    @State private var errorMessage: String? = nil
    @Environment(\.presentationMode) var presentationMode
    
    let onPostEdited: () -> Void
    
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
                                   onPostEdited()
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
        let samplePost = Post(id: 169, text: "# Hello (again)!", date: "2023-03-28T19:35:19.000Z", images: [], userId: 24, username: "dkaspersky", visibleName: "dkaspersky", profilePictureUrl: "https://bangerify-media.s3.eu-central-1.amazonaws.com/cb20909195147611afd97de1210a3e5f", likes: 0, liked: 1, grade: 1)
        EditPostView(post: samplePost, onPostEdited: {})
            .sheet(isPresented: .constant(true)) {
                EditPostView(post: samplePost, onPostEdited: {})
            }
    }
}

