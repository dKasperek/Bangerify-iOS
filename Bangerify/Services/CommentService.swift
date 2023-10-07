//
//  CommentService.swift
//  Bangerify
//
//  Created by David Kasperek on 16/03/2023.
//

import Foundation
import SwiftyJSON
import Alamofire

class CommentService {
    
    let authenticationService = AuthenticationService.shared
    static let shared = CommentService()
    
    func loadComments(for postId: Int, completion: @escaping ([Comment]) -> Void) {
        guard let url = URL(string: "http://144.24.165.119:8080/api/loadComments") else { fatalError("Missing URL") }
        
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
                let json = try JSON(data: data)
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let comments = try decoder.decode([String: [Comment]].self, from: json.rawData())["comments"]!
                completion(comments)
            } catch let error {
                print("Error decoding: ", error)
            }
        }
        dataTask.resume()
    }
    
    func sendComment(postId: Int, text: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "http://144.24.165.119:8080/api/commentPost") else { fatalError("Missing URL") }
        
        authenticationService.getValidAccessToken { accessToken in
            guard let accessToken = accessToken else {
                print("Error getting valid access token")
                return
            }
            
            let parameters: [String: Any] = [
                "postId": postId,
                "text": text
            ]
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response { response in
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
