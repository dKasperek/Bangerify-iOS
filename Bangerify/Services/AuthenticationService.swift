//
//  AuthenticationService.swift
//  Bangerify
//
//  Created by David Kasperek on 16/03/2023.
//

import Foundation
import Combine
import SwiftKeychainWrapper
import Alamofire
import JWTDecode

struct TokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
}

struct RegisterResponse: Decodable {
    let message: String
    let usernameExist: Bool?
    let emailExist: Bool?
}

class AuthenticationService: ObservableObject {
    
    @Published var isAuthenticated: Bool = false
    private let keychain = KeychainWrapper.standard
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        isAuthenticated = keychain.string(forKey: "refreshToken") != nil
    }
    
    func login(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "http://3.71.193.242:8080/api/auth/login") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let loginData = [
            "username": username,
            "password": password
        ]
        
        do {
            let requestData = try JSONEncoder().encode(loginData)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = requestData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                if let data = data {
                    do {
                        let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                        DispatchQueue.main.async {
                            self.storeAccessToken(tokenResponse.accessToken)
                            self.storeRefreshToken(tokenResponse.refreshToken)
                            completion(.success(tokenResponse.accessToken))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
    
    func register(username: String, email: String, password: String, completion: @escaping (Result<RegisterResponse, Error>) -> Void) {
        guard let url = URL(string: "http://3.71.193.242:8080/api/auth/register") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let registerData = [
            "username": username,
            "email": email,
            "password": password
        ]
        
        do {
            let requestData = try JSONEncoder().encode(registerData)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = requestData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                if let data = data {
                    do {
                        let jsonResponse = try JSONDecoder().decode(RegisterResponse.self, from: data)
                        
                        DispatchQueue.main.async {
                            completion(.success(jsonResponse))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
    
    func isAccessTokenValid() -> Bool {
        do {
            let jwt = try decode(jwt: getAccessToken() ?? "")
            let expirationDate = jwt.expiresAt
            return expirationDate?.compare(Date()) == .orderedDescending
        } catch {
            return false
        }
    }
    
    func refreshAccessToken(completion: @escaping (String?) -> Void) {
        if let refreshToken = getRefreshToken() {
            let parameters = ["token": refreshToken]
            AF.request("http://3.71.193.242:8080/api/token/refresh", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        print("Raw response data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")")
                        
                        do {
                            let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                            print("Old refresh token:", refreshToken)
                            print("New refresh token:", tokenResponse.refreshToken)
                            print("New access token:", tokenResponse.accessToken)
                            self.storeAccessToken(tokenResponse.accessToken)
                            self.storeRefreshToken(tokenResponse.refreshToken)
                            completion(tokenResponse.accessToken)
                        } catch let decodingError {
                            print("Decoding error: \(decodingError.localizedDescription)")
                            completion(nil)
                        }
                        
                    case .failure(let error):
                        print("Error refreshing access token: \(error.localizedDescription)")
                        completion(nil)
                    }
                }
        } else {
            completion(nil)
        }
    }

    
    func getValidAccessToken(completion: @escaping (String?) -> Void) {
        if let accessToken = getAccessToken() {
            do {
                let jwt = try decode(jwt: accessToken)
                let expirationDate = jwt.expiresAt
                
                if let expirationDate = expirationDate, expirationDate.compare(Date()) == .orderedDescending {
                    print("No need to refresh")
                    completion(accessToken)
                } else {
                    print("Starting refresh")
                    refreshAccessToken { refreshedAccessToken in
                        completion(refreshedAccessToken)
                    }
                }
            } catch {
                print("Starting refresh")
                refreshAccessToken { refreshedAccessToken in
                    completion(refreshedAccessToken)
                }
            }
        } else {
            completion(nil)
        }
    }
    
    func storeAccessToken(_ token: String) {
        keychain.set(token, forKey: "accessToken")
    }
    
    func getAccessToken() -> String? {
        return keychain.string(forKey: "accessToken")
    }
    
    func storeRefreshToken(_ token: String) {
        keychain.set(token, forKey: "refreshToken")
    }
    
    func getRefreshToken() -> String? {
        return keychain.string(forKey: "refreshToken")
    }
    
    func clearToken() {
        keychain.removeAllKeys()
        isAuthenticated = false
    }
}
