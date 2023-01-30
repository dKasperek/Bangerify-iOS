//
//  ProfileView.swift
//  Bangerify
//
//  Created by David Kasperek on 29/01/2023.
//

import SwiftUI
import MarkdownUI
import Kingfisher
import Network


struct ProfileView: View {
    var username: String
    @EnvironmentObject var network: Network
    
    var body: some View {
        List {
            VStack {
                HStack {
                    KFImage(URL(string: network.profile.profilePictureUrl))
                        .cancelOnDisappear(true)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 75, height: 75)
                    VStack (alignment: .leading){
                        HStack {
                            Text(network.profile.visibleName)
                                .font(.title2)
                                .fontWeight(.semibold)
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
                
                Markdown(network.profile.bio)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                
            }
            
            Section {
                Text("TU BĘDĄ POSTY").font(.headline)
            }
            
            .onAppear {
                network.getProfile(username: username)
            }
            .refreshable {
                network.getProfile(username: username)
            }
            .onDisappear {
                network.profile = Profile(
                    visibleName: "",
                    bio: "",
                    grade: 0,
                    creationDate: "",
                    profilePictureUrl: ""
                )
            }
            
        }
    }
    
    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileView(username: "wojciehc")
                .environmentObject(Network())
        }
    }
}
