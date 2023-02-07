//
//  PostView.swift
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
    
    let post: Post
    let commentCount: Int
    
    public var body: some View {
        VStack {
            ZStack {
                HStack {
                    KFImage(URL(string: post.profilePictureUrl))
                        .placeholder {
                            Image(systemName: "hourglass")
                                .foregroundColor(.gray)
                        }
                        .cancelOnDisappear(true)
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
                NavigationLink (destination: ProfileView(username: post.username)) {
                    EmptyView()
                }.frame(width: 0).opacity(0)
            }
            
            ForEach(divideToArray(rawString: post.text), id: \.self) { item in
                if item.hasPrefix("!["){
                    let startIndex = item.firstIndex(of: "(")
                    let url = String(item[startIndex!...])
                    KFImage(URL(string: String(url.dropFirst())))
                        .placeholder {
                            Image(systemName: "hourglass")
                                .foregroundColor(.gray)
                        }
                        .cancelOnDisappear(true)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                else {
                    Markdown(item)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }.id(post.id)
            
            HStack {
                Image(systemName: "heart")
                    .font(Font.system(.title3))
                Text(String(post.likes))
                Spacer()
                Image(systemName: "bubble.left")
                    .font(Font.system(.title3))
                Text(String(commentCount)).font(Font.system(.title3))
            } .frame(maxWidth: .infinity, alignment: .leading)
                .padding(5)
        }
    }
}
