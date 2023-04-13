//
//  PostObject.swift
//  Bangerify
//
//  Created by David Kasperek on 11/04/2023.
//

import Foundation
import Combine

public class PostObject: ObservableObject{
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
    
    init(id: Int, text: String, date: String, images: [URL]?, userId: Int, username: String, visibleName: String, profilePictureUrl: String?, grade: Int, likes: Int, liked: Int) {
        self.id = id
        self.text = text
        self.date = date
        self.images = images
        self.userId = userId
        self.username = username
        self.visible_name = visibleName
        self.profilePictureUrl = profilePictureUrl ?? ""
        self.likes = likes
        self.liked = liked
        self.comments = nil
        self.grade = grade
    }
    
    convenience init(from post: Post) {
        self.init(
            id: post.id,
            text: post.text,
            date: post.date,
            images: post.images,
            userId: post.userId,
            username: post.username,
            visibleName: post.visible_name,
            profilePictureUrl: post.profilePictureUrl,
            grade: post.grade
        )
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
