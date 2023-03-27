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
    
    let comList: [Comment]
    
    public var body: some View {
        ForEach(comList, id: \.self) { comment in
            Divider()
            VStack{
                HStack{
                    if let url = URL(string: comment.profilePictureUrl) {
                        KFImage(url)
                            .placeholder {
                                Image(systemName: "hourglass")
                                    .foregroundColor(.gray)
                            }
                            .cancelOnDisappear(true)
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 30, height: 30)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .foregroundColor(.gray)
                            .clipShape(Circle())
                            .frame(width: 30, height: 30)
                    }
                    
                    Text(comment.visibleName)
                        .font(.subheadline)
                        .foregroundColor(getGradeColor(grade: comment.grade))
                    
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
