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
                
                if let postArray = json.array {
                    for postJSON in postArray {
                        let post = Post(id: postJSON["id"].intValue,
                                        text: postJSON["text"].stringValue,
                                        date: postJSON["date"].stringValue,
                                        userId: postJSON["userId"].intValue,
                                        username: postJSON["username"].stringValue,
                                        visibleName: postJSON["visible_name"].stringValue,
                                        profilePictureUrl: postJSON["profilePictureUrl"].stringValue) // TODO: Nil
                        decodedPosts.append(post)
//                        self.getLikes(postId: postJSON["id"].intValue)
//                        self.getComments(postId: postJSON["id"].intValue)
                    }
                }
                completion(decodedPosts)
            } catch let error {
                print("Error decoding: ", error)
            }
        }
        dataTask.resume()
    }
}
