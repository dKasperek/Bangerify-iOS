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
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                ForEach(divideMentionsFromText(rawString: post.text), id: \.self) { item in
                    if item.hasPrefix("@") {
                        let username = String(item.dropFirst())
                        NavigationLink(destination: ProfileView(username: username)) {
                            MarkdownText("@\(username)")
                                .foregroundColor(.blue)
                        }
                    }
                    else {
                        MarkdownText(item)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(nil)
        }
        .padding(5)
    }
}
