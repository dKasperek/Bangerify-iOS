//
//  Post.swift
//  Bangerify
//
//  Created by David Kasperek on 25/01/2023.
//

import Foundation

struct Post: Identifiable{
    let id: Int
    let text: String
    let date: String
    let userId: Int
    let username: String
    let visibleName: String
    let profilePictureUrl: String
    var likes: Int = 0
}

struct Likes: Codable {
    let likes: Int
}

struct Comments: Codable {
    let comments: [Comment]
}

struct Comment: Codable, Hashable {
    let text: String
    let date: String
    let grade: Int
    let username: String
    let visible_name: String
    let id: Int
    let profilePictureUrl: String
    let userId: Int
}

