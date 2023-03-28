//
//  PostHeaderComponent.swift
//  Bangerify
//
//  Created by David Kasperek on 28/03/2023.
//

import SwiftUI
import Kingfisher

struct PostHeaderComponent: View {
    var post: Post
    
    var body: some View {
        HStack {
            if let url = URL(string: post.profilePictureUrl ?? "") {
                KFImage(url)
                    .placeholder {
                        Image(systemName: "hourglass")
                            .foregroundColor(.gray)
                    }
                    .cancelOnDisappear(true)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
            }
            
            VStack (alignment: .leading){
                HStack {
                    Text(post.visible_name)
                        .font(.headline)
                        .foregroundColor(getGradeColor(grade: post.grade))
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
    }
}
