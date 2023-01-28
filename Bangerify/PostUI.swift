//
//  PostUI.swift
//  Bangerify
//
//  Created by David Kasperek on 28/01/2023.
//

import Foundation
import SwiftUI
import Network
import MarkdownUI
import Kingfisher

public struct PostView: View {
    @EnvironmentObject var network: Network
    var post: Post
    var commentCount: Int
    
    public var body: some View {
        VStack {
            HStack {
                KFImage(URL(string: post.profilePictureUrl))
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                VStack (alignment: .leading){
                    HStack {
                        Text(post.visibleName)
                            .font(.headline)
                        Spacer()
                        Image(systemName: "ellipsis")
                            .font(Font.system(.caption))
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("@" + post.username).font(.subheadline)
                        Spacer()
                        Text(formatDate(dateString: post.date))
                            .font(.caption)
                            .fontWeight(.light)
                            .foregroundColor(.secondary)
                        
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
            } .padding(5)
            
            Markdown(post.text)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Image(systemName: "heart")
                    .font(Font.system(.title3))
                Text(String(network.getLikeCount(postId: post.id)))
                Spacer()
                Image(systemName: "bubble.left")
                    .font(Font.system(.title3))
                Text(String(commentCount)).font(Font.system(.title3))
            } .frame(maxWidth: .infinity, alignment: .leading)
                .padding(5)
        }
    }
}

public struct CommentView: View {
    @EnvironmentObject var network: Network
    var post: Post
    public var body: some View {
        let comList = network.comments.first(where: {$0.0 == post.id})?.1
        ForEach(comList!, id: \.self) { comment in
            VStack{
                HStack{
                    KFImage(URL(string: comment.profilePictureUrl))
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 30, height: 30)
                    Text(comment.visible_name)
                        .font(.subheadline)
                    Spacer()
                    Text(formatDate(dateString: comment.date))
                        .font(.caption)
                        .fontWeight(.light)
                        .foregroundColor(.secondary)
                    
                }
                Markdown(comment.text)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

func formatDate(dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let date = dateFormatter.date(from: dateString)
    dateFormatter.dateFormat = "dd.MM.yyyy / HH:mm"
    return dateFormatter.string(from: date!)
}
