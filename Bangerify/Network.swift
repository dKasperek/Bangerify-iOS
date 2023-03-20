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
    @Published var likes: [(Int, Int)] = []
    @Published var comments: [(Int, [Comment])] = []
    @Published var profile = Profile(
        visibleName: "",
        bio: "",
        grade: 0,
        creationDate: "",
        profilePictureUrl: ""
    )

    
//    func getPosts() {
//        guard let url = URL(string: "http://3.71.193.242:8080/api/getPosts") else { fatalError("Missing URL") }
//
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "POST"
//
//        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//            if let data = data, error == nil {
//                do {
//                    let json = try JSON(data: data)
//                    var decodedPosts: [Post] = []
//
//                    if let postArray = json.array {
//                        for postJSON in postArray {
//                            let post = Post(id: postJSON["id"].intValue,
//                                            text: postJSON["text"].stringValue,
//                                            date: postJSON["date"].stringValue,
//                                            images: nil,
//                                            userId: postJSON["userId"].intValue,
//                                            username: postJSON["username"].stringValue,
//                                            visibleName: postJSON["visible_name"].stringValue,
//                                            profilePictureUrl: postJSON["profilePictureUrl"].stringValue)
//                            decodedPosts.append(post)
//                            self.getLikes(postId: postJSON["id"].intValue)
//                            self.getComments(postId: postJSON["id"].intValue)
//                        }
//                    }
//                    DispatchQueue.main.async {
//                        self.posts = decodedPosts
//                    }
//                } catch let error {
//                    print(error.localizedDescription)
//                }
//            } else {
//                print(error?.localizedDescription ?? "No data")
//            }
//        }
//
//        dataTask.resume()
//    }
//
//    func getLikes(postId: Int) {
//        guard let url = URL(string: "http://3.71.193.242:8080/api/loadLikes") else { fatalError("Missing URL") }
//
//        var bodyData = URLComponents()
//        bodyData.queryItems = [URLQueryItem(name: "postId", value: String(postId))]
//
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "POST"
//        urlRequest.httpBody = bodyData.query?.data(using: .utf8)
//
//        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//            if let error = error {
//                print("Request error: ", error)
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse else { return }
//
//            if response.statusCode == 200 {
//                guard let data = data else { return }
//                DispatchQueue.main.async {
//                    do {
//                        let likes = try JSONDecoder().decode(Likes.self, from: data)
//                        self.likes.append((postId, likes.likes))
//                    } catch let error {
//                        print("Error decoding: ", error)
//                    }
//                }
//            }
//        }
//        dataTask.resume()
//    }
//
//    func getLikeCount(postId: Int) -> Int {
//        if let post = likes.first(where: {$0.0 == postId})?.1 {
//            return post
//        } else {
//            return 0
//        }
//    }
//
//    func getComments(postId: Int) {
//        guard let url = URL(string: "http://3.71.193.242:8080/api/loadComments") else { fatalError("Missing URL") }
//
//        var bodyData = URLComponents()
//        bodyData.queryItems = [URLQueryItem(name: "postId", value: String(postId))]
//
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "POST"
//        urlRequest.httpBody = bodyData.query?.data(using: .utf8)
//
//        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//            if let error = error {
//                print("Request error: ", error)
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse else { return }
//
//            if response.statusCode == 200 {
//                guard let data = data else { return }
//                DispatchQueue.main.async {
//                    do {
//                        let json = try JSON(data: data)
//                        let comments = json["comments"].arrayValue
//                        var decodedComments: [Comment] = []
//
//                        if !comments.isEmpty {
//                            for comment in comments {
//                                let decodedComment = Comment(text: comment["text"].stringValue,
//                                                             date: comment["date"].stringValue,
//                                                             grade: comment["grade"].intValue,
//                                                             username: comment["username"].stringValue,
//                                                             visibleName: comment["visible_name"].stringValue,
//                                                             id: comment["id"].intValue,
//                                                             profilePictureUrl: comment["profilePictureUrl"].stringValue,
//                                                             userId: comment["userId"].intValue)
//                                decodedComments.append(decodedComment)
//                            }
//                        }
//                        self.comments.append((postId, decodedComments))
//
//                    } catch let error {
//                        print("Error decoding: ", error)
//                    }
//                }
//            }
//        }
//        dataTask.resume()
//    }
//
//    func getCommentCount(postId: Int) -> Int {
//        if let post = comments.first(where: {$0.0 == postId})?.1 {
//            return post.count
//        } else {
//            return 0
//        }
//    }
    
    func getProfile(username: String){
        let profileUrl = "http://3.71.193.242:8080/api/userData/" + username
        guard let url = URL(string: profileUrl) else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let profile = try JSONDecoder().decode([Profile].self, from: data)
                        self.profile = profile.first!
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        dataTask.resume()
    }
}

