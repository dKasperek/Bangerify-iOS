//
//  PostObject.swift
//  Bangerify
//
//  Created by David Kasperek on 11/04/2023.
//

import Foundation
import Combine

public class PostObject: ObservableObject {
    let id: Int
    @Published var text: String
    let date: String
    let images: [URL]?
    
    let userId: Int
    let username: String
    let visible_name: String
    let profilePictureUrl: String
    let grade: Int
    
    @Published var likes: Int?
    @Published var liked: Int?
    @Published var comments: [Comment]?
    
    init(id: Int, text: String, date: String, images: [URL]?, userId: Int, username: String, visibleName: String, profilePictureUrl: String?, grade: Int) {
        self.id = id
        self.text = text
        self.date = date
        self.images = images
        self.userId = userId
        self.username = username
        self.visible_name = visibleName
        self.profilePictureUrl = profilePictureUrl ?? ""
        self.likes = nil
        self.liked = nil
        self.comments = nil
        self.grade = grade
    }
    
    func updateLikes() {
        LikeService.shared.getLikeCountAuth(for: self.id) { authenticatedLikes in
            DispatchQueue.main.async {
                self.likes = authenticatedLikes.likes
                self.liked = authenticatedLikes.liked
            }
        }
    }
    
    func updateComments() {
        CommentService.shared.loadComments(for: self.id) { comments in
            DispatchQueue.main.async {
                self.comments = comments
            }
        }
    }
}
