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
    let authenticationService = AuthenticationService.shared
    
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
                let decodedPosts = posts.sorted(by: { $0.id > $1.id })
                completion(decodedPosts)
                
            case .failure(let error):
                print("Request error: ", error)
                completion(nil)
            }
        }
    }
    
    func loadUserPosts(author: String, completion: @escaping ([Post]?) -> Void) {
        guard let url = URL(string: "http://3.71.193.242:8080/api/getUserPosts") else { fatalError("Missing URL") }

        let parameters: [String: Any] = ["author": author]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: [Post].self) { response in
            switch response.result {
            case .success(let posts):
                let decodedPosts = posts.sorted(by: { $0.id > $1.id })
                completion(decodedPosts)

            case .failure(let error):
                print("Request error: ", error)
                completion(nil)
            }
        }
    }

    

}
