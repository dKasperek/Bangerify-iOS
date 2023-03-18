//
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
    var profilePictureUrl: String? = nil
    var likes: Int = 0
    var liked: Int = 0
}

