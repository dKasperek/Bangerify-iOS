//
//  IsLoggedResponse.swift
//  Bangerify
//
//  Created by David Kasperek on 28/03/2023.
//

import Foundation

struct IsLoggedResponse: Decodable {
    let isLogged: Bool
    let username: String
}
