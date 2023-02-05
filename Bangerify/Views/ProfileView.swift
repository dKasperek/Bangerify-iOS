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
    let username: String
    
    @State private var profile: Profile?
    
    
    var body: some View {
        List {
            if let profile = profile {
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
                
                Section {
                    Text("TU BĘDĄ POSTY").font(.headline)
                }
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            self.loadProfile()
        }
        .refreshable {
            self.loadProfile()
        }
    }
    
    private func loadProfile() {
        let profileService = ProfileService()
        profileService.loadProfile(username: self.username) { profile in
            self.profile = profile
        }
    }
    
    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileView(username: "wojciehc")
                .environmentObject(Network())
        }
    }

}
