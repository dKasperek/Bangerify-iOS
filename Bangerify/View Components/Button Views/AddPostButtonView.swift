//
//  AddPostButtonView.swift
//  Bangerify
//
//  Created by David Kasperek on 06/05/2023.
//

import SwiftUI

struct AddPostButtonView: View {
    @Binding var showAddPostView: Bool
    @EnvironmentObject var postService: PostService
    
    var body: some View {
        Button(action: {
            showAddPostView.toggle()
        }) {
            Image(systemName: "square.and.pencil")
                .foregroundColor(.primary)
            Text("Add a new post...")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(5)
        .padding(.vertical, 10)
        .cardboardStyle()
        
        .sheet(isPresented: $showAddPostView) {
            AddPostSheet {
                postService.loadPosts(completion: { [weak postService] posts in
                    postService?.posts = posts
                })
            }
        }
    }
}

struct AddPostButtonView_Previews: PreviewProvider {
    static var showAddPostView = Binding.constant(false)
    static var previews: some View {
        AddPostButtonView(showAddPostView: showAddPostView)
            .environmentObject(PostService())
    }
}
