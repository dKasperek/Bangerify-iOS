//
//  Likes.swift
//  Bangerify
//
//  Created by David Kasperek on 18/03/2023.
//

import Foundation

struct Likes: Codable {
    let likes: Int
}

struct AuthenticatedLikes: Codable {
    let likes: Int
    let liked: Int
}
