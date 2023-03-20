//
//  PostService.swift
//  Bangerify
//
//  Created by David Kasperek on 06/02/2023.
//

import Foundation
import SwiftyJSON
import Alamofire

class PostService: ObservableObject {
    @Published var posts: [Post]?
    let authenticationService = AuthenticationService()
    
    init() {
        loadPosts(completion: { [weak self] posts in
            self?.posts = posts
        })
    }
    
    static let shared = PostService()
    
    func loadPosts(completion: @escaping ([Post]?) -> Void) {
        guard let url = URL(string: "http://3.71.193.242:8080/api/getPosts") else { fatalError("Missing URL") }

        AF.request(url, method: .post).responseDecodable(of: [Post].self) { response in
            switch response.result {
            case .success(let posts):
                var decodedPosts: [Post] = []
                let group = DispatchGroup()

                for post in posts {
                    var postWithLikes = post
                    group.enter()
                    self.getLikeCountAuth(for: post.id) { likeAuth in
                        postWithLikes.likes = likeAuth.likes
                        postWithLikes.liked = likeAuth.liked
                        decodedPosts.append(postWithLikes)
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    decodedPosts.sort(by: { $0.id > $1.id })
                    completion(decodedPosts)
                }
                
            case .failure(let error):
                print("Request error: ", error)
                completion(nil)
            }
        }
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
    
    func loadUserPosts(author: String, completion: @escaping ([Post]?) -> Void) {
        guard let url = URL(string: "http://3.71.193.242:8080/api/getUserPosts") else { fatalError("Missing URL") }
        
        var bodyData = URLComponents()
        bodyData.queryItems = [URLQueryItem(name: "author", value: author)]
        
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
                let json = try JSON(data: data)
                var decodedPosts: [Post] = []
                let group = DispatchGroup()
                
//                if let postArray = json.array {
//                    for postJSON in postArray {
//                        let imagesArray: [URL]? = postJSON["images"].string?.components(separatedBy: "\", \"").compactMap { URL(string: $0.replacingOccurrences(of: "[\"", with: "").replacingOccurrences(of: "\"]", with: "")) }
//                        var post = Post(id: postJSON["id"].intValue,
//                                        text: postJSON["text"].stringValue,
//                                        date: postJSON["date"].stringValue,
//                                        images: imagesArray,
//                                        userId: postJSON["userId"].intValue,
//                                        username: postJSON["username"].stringValue,
//                                        visibleName: postJSON["visible_name"].stringValue,
//                                        profilePictureUrl: postJSON["profilePictureUrl"].stringValue) // TODO: Nil
//                        group.enter()
//                        self.getLikeCount(for: postJSON["id"].intValue) { likeCount in
//                            post.likes = likeCount
//                            decodedPosts.append(post)
//                            group.leave()
//                        }
//                    }
//                }
                group.notify(queue: .main) {
                    decodedPosts.sort(by: { $0.id > $1.id })
                    completion(decodedPosts)
                }
            } catch let error {
                print("Error decoding: ", error)
            }
        }
        dataTask.resume()
    }
}
