//
//  ProfileService.swift
//  Bangerify
//
//  Created by David Kasperek on 05/02/2023.
//

import Foundation
import Alamofire

class ProfileService {
    
    static let shared = ProfileService()
    
    func loadProfile(username: String, completion: @escaping (Profile?) -> Void) {
        let profileUrl = "http://3.71.193.242:8080/api/userData/\(username)"
        
        AF.request(profileUrl, method: .post).responseDecodable(of: [Profile].self) { response in
            switch response.result {
            case .success(let profiles):
                completion(profiles.first)
            case .failure(let error):
                print("Request error: ", error)
                completion(nil)
            }
        }
    }
    
}
