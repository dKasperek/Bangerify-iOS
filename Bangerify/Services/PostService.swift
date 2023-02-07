//
//  PostService.swift
//  Bangerify
//
//  Created by David Kasperek on 06/02/2023.
//

import Foundation
import SwiftyJSON

class PostService {
    
    static let shared = PostService()
    
    func loadPosts(completion: @escaping ([Post]?) -> Void) {
        guard let url = URL(string: "http://3.71.193.242:8080/api/getPosts") else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
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
                let json = try JSON(data: data)
                var decodedPosts: [Post] = []
                let group = DispatchGroup()
                
                if let postArray = json.array {
                    for postJSON in postArray {
                        var post = Post(id: postJSON["id"].intValue,
                                        text: postJSON["text"].stringValue,
                                        date: postJSON["date"].stringValue,
                                        userId: postJSON["userId"].intValue,
                                        username: postJSON["username"].stringValue,
                                        visibleName: postJSON["visible_name"].stringValue,
                                        profilePictureUrl: postJSON["profilePictureUrl"].stringValue) // TODO: Nil
                        group.enter()
                        self.getLikeCount(for: postJSON["id"].intValue) { likeCount in
                            post.likes = likeCount
                            decodedPosts.append(post)
                            group.leave()
                        }
                    }
                }
                group.notify(queue: .main) {
                    completion(decodedPosts)
                }
            } catch let error {
                print("Error decoding: ", error)
            }
        }
        dataTask.resume()
    }
    
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
}