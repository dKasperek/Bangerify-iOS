//
//  Post.swift
//  Bangerify
//
//  Created by David Kasperek on 25/01/2023.
//

import Foundation

struct Post: Identifiable, Decodable {
    var id: Int
    var text: String
    var date: Date
    var userId: Int
    var username: String
    var visible_name: String
    var profilePictureUrl: URL
}
