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
    
    let onPostCreated: () -> Void
    
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
                    let images: [String] = []
                    PostService.shared.createPost(postData: postContent, images: images) { result in
                        switch result {
                        case .success:
                            DispatchQueue.main.async {
                                onPostCreated()
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

struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        AddPostView(onPostCreated: {})
            .sheet(isPresented: .constant(true)) {
                AddPostView(onPostCreated: {})
            }
    }
}

