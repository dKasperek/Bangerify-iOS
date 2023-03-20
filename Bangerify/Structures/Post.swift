//
//
//  Post.swift
//  Bangerify
//
//  Created by David Kasperek on 25/01/2023.
//

import Foundation

struct Post: Identifiable, Decodable{
    let id: Int
    let text: String
    let date: String
    let images: [URL]?
    let userId: Int
    let username: String
    let visible_name: String
    var profilePictureUrl: String? = nil
    var likes: Int = 0
    var liked: Int = 0
    
    private enum CodingKeys: String, CodingKey {
        case id, text, date, images, userId, username, visible_name, profilePictureUrl
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        text = try container.decode(String.self, forKey: .text)
        date = try container.decode(String.self, forKey: .date)
        let imagesString = try container.decode(String?.self, forKey: .images)
        images = imagesString?.components(separatedBy: "\", \"").compactMap { URL(string: $0.replacingOccurrences(of: "[\"", with: "").replacingOccurrences(of: "\"]", with: "")) }
        userId = try container.decode(Int.self, forKey: .userId)
        username = try container.decode(String.self, forKey: .username)
        visible_name = (try? container.decode(String.self, forKey: .visible_name)) ?? username
        profilePictureUrl = try container.decode(String?.self, forKey: .profilePictureUrl)
    }
    
    // Old initialization method
    init(id: Int, text: String, date: String, images: [URL]?, userId: Int, username: String, visibleName: String, profilePictureUrl: String?, likes: Int, liked: Int) {
        self.id = id
        self.text = text
        self.date = date
        self.images = images
        self.userId = userId
        self.username = username
        self.visible_name = visibleName
        self.profilePictureUrl = profilePictureUrl
        self.likes = likes
        self.liked = liked
    }

}

