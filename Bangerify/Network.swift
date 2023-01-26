//
//  Network.swift
//  Bangerify
//
//  Created by David Kasperek on 25/01/2023.
//

import Foundation
import SwiftyJSON

class Network: ObservableObject {
    @Published var posts: [Post] = []
    
    func getPosts() {
        guard let url = URL(string: "http://3.71.193.242:8080/api/getPosts") else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data, error == nil {
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
                                            profilePictureUrl: postJSON["profilePictureUrl"].stringValue)
                            decodedPosts.append(post)
                        }
                    }
                    DispatchQueue.main.async {
                        self.posts = decodedPosts
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            } else {
                print(error?.localizedDescription ?? "No data")
            }
        }

            dataTask.resume()
        }
    }
    
