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
                NavigationLink(destination: ProfileView(username: comment.username)) {
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
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: ProfileView(username: comment.username)) {
                    Text(comment.visibleName)
                        .font(.headline)
                        .foregroundColor(getGradeColor(grade: comment.grade))
                }
                .buttonStyle(PlainButtonStyle())
                
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
