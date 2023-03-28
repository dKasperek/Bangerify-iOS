//
//  ProfileHeaderComponent.swift
//  Bangerify
//
//  Created by David Kasperek on 08/02/2023.
//

import SwiftUI
import MarkdownUI
import Kingfisher
import Network


public struct ProfileHeaderComponent: View {
    
    let profile: Profile
    let username: String
    
    public var body: some View {
        VStack {
            HStack {
                KFImage(URL(string: profile.profilePictureUrl ?? ""))
                    .placeholder {
                        Image(systemName: "hourglass")
                            .foregroundColor(.gray)
                    }
                    .cancelOnDisappear(true)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 75, height: 75)
                
                VStack (alignment: .leading){
                    HStack {
                        Text(profile.visibleName)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(getGradeColor(grade: profile.grade))
                        Spacer()
                        Image(systemName: "ellipsis")
                            .font(Font.system(.body))
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("@" + username)
                            .font(.headline)
                            .fontWeight(.light)
                        
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
            } .padding(5)
            
            Markdown(profile.bio ?? "Empty bio")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
            
        }
    }
}
