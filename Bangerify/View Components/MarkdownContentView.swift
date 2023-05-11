//
//  MarkdownContentView.swift
//  Bangerify
//
//  Created by David Kasperek on 28/03/2023.
//

import SwiftUI
import MarkdownText

struct MarkdownContentView: View {
    @ObservedObject var post: PostObject
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                ForEach(post.text.components(separatedBy: "\n"), id: \.self) { item in
                    if item.contains("@") {
                        let newString = enableMentions(rawString: item)
                        Text(makeAttributedText(rawString: newString))
                            .environment(\.openURL, OpenURLAction { url in
                                ProfileView(username: url.absoluteString)
                                return .handled
                            })
                    }
                    else {
                        if item.hasPrefix("#") {
                            Text(makeAttributedText(rawString: item))
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        else {
                            Text(makeAttributedText(rawString: item))
                        }
                    }
                    //                    if item.hasPrefix("@") {
                    //                        let username = String(item.dropFirst())
                    //                        NavigationLink(destination: ProfileView(username: username)) {
                    //                            Text("@\(username)")
                    //                                .foregroundColor(.blue)
                    //                        }
                    //                    }
                    //                    else {
                    //                        Text(enableMentions(rawString: post.text))
                    //                            .environment(\.openURL, OpenURLAction { url in
                    //                                print(url)
                    //                                return .handled
                    //                            })
                    //                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(nil)
        }
        .padding(5)
    }
}
