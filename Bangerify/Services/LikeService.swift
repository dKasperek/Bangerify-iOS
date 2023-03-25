//
//  LikeService.swift
//  Bangerify
//
//  Created by David Kasperek on 25/03/2023.
//

import Foundation
import Alamofire

class LikeService {
    let authenticationService = AuthenticationService.shared
    
    static let shared = LikeService()

    func getLikeCount(for postId: Int, completion: @escaping (Int) -> Void) {
        guard let url = URL(string: "http://3.71.193.242:8080/api/loadLikes") else { fatalError("Missing URL") }
        
        var bodyData = URLComponents()
        bodyData.queryItems = [URLQueryItem(name: "postId", value: String(postId))]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = bodyData.query?.data(using: .utf8)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            
            guard let data = data else {
                print("Invalid data from request: ", url)
                return
            }
            
            do {
                let likes = try JSONDecoder().decode(Likes.self, from: data)
                completion(likes.likes)
            } catch let error {
                print("Error decoding: ", error)
            }
        }
        dataTask.resume()
    }
    
    func getLikeCountAuth(for postId: Int, completion: @escaping (AuthenticatedLikes) -> Void) {
        guard let url = URL(string: "http://3.71.193.242:8080/api/loadLikesAuth") else { fatalError("Missing URL") }
        
        authenticationService.getValidAccessToken { accessToken in
            guard let accessToken = accessToken else {
                print("Error getting valid access token")
                return
            }
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(accessToken)"
            ]
            
            let parameters: Parameters = [
                "postId": postId
            ]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: AuthenticatedLikes.self) { response in
                switch response.result {
                case .success(let authenticatedLikes):
                    completion(authenticatedLikes)
                case .failure(let error):
                    print("Request error: ", error)
                }
            }
        }
    }
}
