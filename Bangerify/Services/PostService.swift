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
    @Published var posts: [PostObject]?
    let authenticationService = AuthenticationService.shared
    
    init() {
        loadPosts(completion: { [weak self] posts in
            self?.posts = posts
        })
    }
    
    static let shared = PostService()
    
    func loadPosts(lastPostId: Int? = nil, completion: @escaping ([PostObject]?) -> Void) {
        guard let url = URL(string: "http://3.71.193.242:8080/api/getPosts") else { fatalError("Missing URL") }
        
        let parameters: [String: Any] = lastPostId != nil ? ["lastPostId": lastPostId!] : [:]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: [Post].self) { response in
            switch response.result {
            case .success(let posts):
                let sortedPosts = posts.sorted(by: { $0.id > $1.id })
                let postObjects = sortedPosts.map { PostObject(from: $0) }
                completion(postObjects)
                
            case .failure(let error):
                print("Request error: ", error)
                completion(nil)
            }
        }
    }

    
    func loadUserPosts(author: String, completion: @escaping ([PostObject]?) -> Void) {
        guard let url = URL(string: "http://3.71.193.242:8080/api/getUserPosts") else { fatalError("Missing URL") }
        
        let parameters: [String: Any] = ["author": author]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: [Post].self) { response in
            switch response.result {
            case .success(let posts):
                let decodedPosts = posts.map { PostObject(from: $0) }
                completion(decodedPosts)
                
            case .failure(let error):
                print("Request error: ", error)
                completion(nil)
            }
        }
    }
    
    
    func createPost(postData: String, images: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "http://3.71.193.242:8080/api/createPost") else { fatalError("Missing URL") }
        
        authenticationService.getValidAccessToken { accessToken in
            guard let accessToken = accessToken else {
                print("Error getting valid access token")
                return
            }
            
            let postDataDictionary = ["post": postData] as [String: Any]
            let parameters: [String: Any] = [
                "postData": postDataDictionary,
                "images": images
            ]
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.allHTTPHeaderFields = headers.dictionary
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                urlRequest.httpBody = jsonData
            } catch {
                completion(.failure(error))
                return
            }
            
            AF.request(urlRequest).response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func editPost(postId: Int, newText: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "http://3.71.193.242:8080/api/savePost") else { fatalError("Missing URL") }
        
        authenticationService.getValidAccessToken { accessToken in
            guard let accessToken = accessToken else {
                print("Error getting valid access token")
                return
            }
            
            let parameters: [String: Any] = [
                "postId": postId,
                "text": newText
            ]
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.allHTTPHeaderFields = headers.dictionary
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                urlRequest.httpBody = jsonData
            } catch {
                completion(.failure(error))
                return
            }
            
            AF.request(urlRequest).response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func deletePost(postId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "http://3.71.193.242:8080/api/deletePost") else { fatalError("Missing URL") }
        
        authenticationService.getValidAccessToken { accessToken in
            guard let accessToken = accessToken else {
                print("Error getting valid access token")
                return
            }
            
            let parameters: [String: Any] = ["postId": postId]
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.allHTTPHeaderFields = headers.dictionary
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                urlRequest.httpBody = jsonData
            } catch {
                completion(.failure(error))
                return
            }
            
            AF.request(urlRequest).response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    
}
