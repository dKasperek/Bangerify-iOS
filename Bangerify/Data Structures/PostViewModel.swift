//
//  PostViewModel.swift
//  Bangerify
//
//  Created by David Kasperek on 26/03/2023.
//

import Foundation

class PostViewModel: ObservableObject {
    @Published var post: Post
    @Published var likes: Int = 0
    @Published var liked: Int = 0
    @Published var comments: [Comment]?
    
    private var hasLoadedData: Bool = false
    private var postChangedText: Bool = false
    
    init(post: Post) {
        self.post = post
        loadData()
    }
    
    func loadData() {
        if !hasLoadedData {
            loadComments()
            loadLikes()
            hasLoadedData = true
        }
    }
    
    func checkTextChange(){
        if postChangedText {
            
        }
    }
    
    func loadComments() {
        CommentService.shared.loadComments(for: post.id) { comments in
            DispatchQueue.main.async {
                self.comments = comments
            }
        }
    }
    
    private func loadLikes() {
        LikeService.shared.loadLikes(for: post.id) { likes, liked in
            DispatchQueue.main.async {
                self.likes = likes
                self.liked = liked ?? 0
            }
        }
    }
    
    func updatePostText(newText: String) {
        post.text = newText
        
    }
}
