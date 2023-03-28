//
//  SingleCommentView.swift
//  Bangerify
//
//  Created by David Kasperek on 28/03/2023.
//

import Foundation
import SwiftUI
import Kingfisher

public struct SingleCommentView: View {
    var comment: Comment
    
    public var body: some View {
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
