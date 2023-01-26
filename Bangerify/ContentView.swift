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
            List {
                VStack {
                    HStack {
                        AsyncImage(url: URL(string: "https://media2.giphy.com/media/wW95fEq09hOI8/200w.gif?cid=6c09b9523v6rshbaqtwf38cnivpg155eci9jhqm71ptobvnu&rid=200w.gif&ct=g")) { image in image
                                .resizable()
                        } placeholder: {
                            Color.red
                        }
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                        VStack (alignment: .leading){
                            HStack {
                                Text("wojciehc")
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "ellipsis")
                                    .font(Font.system(.caption))
                                    .foregroundColor(.secondary)
                            }
                            HStack {
                                Text("@wojciech").font(.caption)
                                Spacer()
                                Text("24.01.2023 / 23:34")                    .font(.caption)
                                    .fontWeight(.light)
                                    .foregroundColor(.secondary)
                                
                            }.frame(maxWidth: .infinity, alignment: .leading)
                            
                        }
                    } .padding(5)
                    Text("Jak cos bedzie nowa baza danych jutro wiec czesc postów bedzie przeniesiona")
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
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Network())
    }
}
