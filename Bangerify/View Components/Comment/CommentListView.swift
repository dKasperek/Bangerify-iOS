//
//  CommentListView.swift
//  Bangerify
//
//  Created by David Kasperek on 28/01/2023.
//

import Foundation
import SwiftUI
import Network
import Kingfisher

public struct CommentListView: View {
    
    let comList: [Comment]
    
    public var body: some View {
        ForEach(comList, id: \.self) { comment in
            Divider()
            
            SingleCommentView(comment: comment)
        }
    }
}
