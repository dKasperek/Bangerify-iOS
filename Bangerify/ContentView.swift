//
//  ContentView.swift
//  Bangerify
//
//  Created by David Kasperek on 25/01/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var network: Network
    
    var body: some View {
        NavigationView {
            List(network.posts) { post in
                VStack {
                    HStack {
                        AsyncImage(url: URL(string: post.profilePictureUrl)) { image in image
                                .resizable()
                        } placeholder: {
                            Color.gray
                        }
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
                                Text("@" + post.username).font(.caption)
                                Spacer()
                                Text(post.date)                    .font(.caption)
                                    .fontWeight(.light)
                                    .foregroundColor(.secondary)
                                
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        }
                    } .padding(5)
                    
                    Text(post.text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Image(systemName: "heart")
                            .font(Font.system(.title3))
                        Text("1").font(Font.system(.title3))
                        Spacer()
                        Image(systemName: "bubble.left")
                            .font(Font.system(.title3))
                        Text("0").font(Font.system(.title3))
                    } .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(5)
                }
                
            }
            .navigationTitle("Bangerify")
            .onAppear{
                network.getPosts()
            }
            .refreshable {
                network.getPosts()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Network())
    }
}
