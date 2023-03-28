//
//  AddPostView.swift
//  Bangerify
//
//  Created by David Kasperek on 28/03/2023.
//

import SwiftUI

struct AddPostView: View {
    @State private var postContent: String = ""
    @State private var showAlert: Bool = false
    @State private var errorMessage: String? = nil
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Spacer().frame(height: 60)
            
            Text("Add a POST")
                .headerTitleStyle()
            
            Spacer().frame(height: 30)
            
            TextField("What's up?", text: $postContent, axis: .vertical)
                .padding()
                .lineLimit(5...8)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Text("* you can use markdown to format text")
                .font(.caption)
            
            Spacer().frame(height: 30)
            
            Button("Sent") {
                if postContent.isEmpty {
                    errorMessage = "The content of the post can't be empty!"
                    showAlert = true
                } else {
                    //                    CommentService.shared.sendComment(postId: viewModel.post.id, text: commentContent) { result in
                    //                        switch result {
                    //                        case .success:
                    //                            DispatchQueue.main.async {
                    //                                viewModel.loadComments()
                    //                                self.presentationMode.wrappedValue.dismiss()
                    //                            }
                    //                        case .failure(let error):
                    //                            errorMessage = error.localizedDescription
                    //                            showAlert = true
                    //                        }
                    //                    }
                }
            }
            .sentButtonStyle()
            
            Spacer()
            
            HStack {
                Spacer().frame(width: 30)
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    VStack {
                        Text("Cancel")
                            .cancelButtonStyle()
                        
                        Spacer().frame(height: 20)
                        Image(systemName: "arrow.down")
                            .foregroundColor(.primary)
                    }
                })
                
                Spacer()
            }
            
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
        }
    }
}

struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        AddPostView()
            .sheet(isPresented: .constant(true)) {
                AddPostView()
            }
    }
}
