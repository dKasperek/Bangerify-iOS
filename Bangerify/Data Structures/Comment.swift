//
//
//  Comment.swift
//  Bangerify
//
//  Created by David Kasperek on 25/01/2023.
//

import Foundation

struct Comment: Codable, Hashable {
    let text: String
    let date: String
    let grade: Int
    let username: String
    let visibleName: String
    let id: Int
    let profilePictureUrl: String
    let userId: Int
}

