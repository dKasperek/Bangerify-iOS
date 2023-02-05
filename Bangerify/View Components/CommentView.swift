//
//  CommentView.swift
//  Bangerify
//
//  Created by David Kasperek on 28/01/2023.
//

import Foundation
import SwiftUI
import Network
import MarkdownUI
import Kingfisher

public struct CommentView: View {
    @EnvironmentObject var network: Network
    var post: Post
    public var body: some View {
        let comList = network.comments.first(where: {$0.0 == post.id})?.1
        ForEach(comList!, id: \.self) { comment in
            VStack{
                HStack{
                    KFImage(URL(string: comment.profilePictureUrl))
                        .placeholder {
                            Image(systemName: "hourglass")
                                .foregroundColor(.gray)
                        }
                        .cancelOnDisappear(true)
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
                Text(comment.text)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
