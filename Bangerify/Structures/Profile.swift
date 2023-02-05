//
//  Profile.swift
//  Bangerify
//
//  Created by David Kasperek on 29/01/2023.
//

import Foundation

struct Profile: Codable {
    var visibleName: String
    var bio: String
    var grade: Int
    var creationDate: String
    var profilePictureUrl: String
    
    enum CodingKeys: String, CodingKey {
        case visibleName = "visible_name"
        case bio
        case grade
        case creationDate
        case profilePictureUrl
    }
}
