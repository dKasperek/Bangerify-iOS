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
    let authenticationService = AuthenticationService.shared
    
    func loadProfile(username: String, completion: @escaping (Profile?) -> Void) {
        let profileUrl = "http://144.24.165.119:8080/api/userData/\(username)"
        
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
    
    func changeVisibleName(newVisibleName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "http://144.24.165.119:8080/api/changeVisibleName") else { fatalError("Missing URL") }
        
        authenticationService.getValidAccessToken { accessToken in
            guard let accessToken = accessToken else {
                print("Error getting valid access token")
                return
            }
            
            let parameters: [String: Any] = [
                "newVisibleName": newVisibleName
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
    
    func changeBio(newBio: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "http://144.24.165.119:8080/api/changeBio") else { fatalError("Missing URL") }
        
        authenticationService.getValidAccessToken { accessToken in
            guard let accessToken = accessToken else {
                print("Error getting valid access token")
                return
            }
            
            let parameters: [String: Any] = [
                "newBio": newBio
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
}
