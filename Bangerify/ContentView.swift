//
//  ContentView.swift
//  Bangerify
//
//  Created by David Kasperek on 25/01/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var network: Network
    
    var body: some View {
        NavigationStack {
            List(network.posts) { post in
                let commentCount = network.getCommentCount(postId: post.id)
                Section(){
                    PostView(post: post, commentCount: commentCount)
                    if commentCount != 0 {
                        let comList = network.comments.first(where: {$0.0 == post.id})?.1
                        ForEach(comList!, id: \.self) { comment in
                            VStack{
                                HStack{
                                    AsyncImage(url: URL(string: comment.profilePictureUrl)) { image in image
                                            .resizable()
                                    } placeholder: {
                                        Color.gray
                                    }
                                        .clipShape(Circle())
                                        .frame(width: 30, height: 30)
                                    Text(comment.visible_name)
                                        .font(.subheadline)
                                    Spacer()
                                    Text(post.date)
                                        .font(.caption)
                                        .fontWeight(.light)
                                        .foregroundColor(.secondary)
                                    
                                }
                                Text(comment.text)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    
                }
            }
            
            .navigationTitle("Bangerify")
            
            .onAppear{
                network.getPosts()
            }
            .refreshable {
                network.getPosts()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Network())
    }
}
