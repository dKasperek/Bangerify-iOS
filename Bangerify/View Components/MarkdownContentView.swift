//
//  MarkdownContentView.swift
//  Bangerify
//
//  Created by David Kasperek on 28/03/2023.
//

import SwiftUI
import Kingfisher
import MarkdownUI

struct MarkdownContentView: View {
    @ObservedObject var post: PostObject
    
    var body: some View {
        VStack {
            ForEach(divideMarkdownTextToArray(rawString: post.text), id: \.self) { item in
                if item.hasPrefix("!["){
                    let startIndex = item.firstIndex(of: "(")
                    let url = String(item[startIndex!...])
                    KFImage(URL(string: String(url.dropFirst())))
                        .placeholder {
                            Image(systemName: "hourglass")
                                .foregroundColor(.gray)
                        }
                        .cancelOnDisappear(true)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                else {
                    Markdown(item)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }.id(post.id)
                .padding(5)
        }
    }
}
