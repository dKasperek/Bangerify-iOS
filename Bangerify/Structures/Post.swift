//
//
//  Post.swift
//  Bangerify
//
//  Created by David Kasperek on 25/01/2023.
//

import Foundation

public struct Post: Identifiable, Decodable{
    public let id: Int
    public let text: String
    public let date: String
    public let images: [URL]?
    public let userId: Int
    public let username: String
    public let visible_name: String
    public var profilePictureUrl: String? = nil
    
    private enum CodingKeys: String, CodingKey {
        case id, text, date, images, userId, username, visible_name, profilePictureUrl
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        text = try container.decode(String.self, forKey: .text)
        date = try container.decode(String.self, forKey: .date)
        let imagesString = try container.decode(String?.self, forKey: .images)
        if let imagesString = imagesString, !imagesString.isEmpty, imagesString != "[]" {
            images = imagesString.components(separatedBy: "\", \"").compactMap {
                URL(string: $0.replacingOccurrences(of: "[\"", with: "").replacingOccurrences(of: "\"]", with: ""))
            }
        } else {
            images = []
        }

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
    }

}

