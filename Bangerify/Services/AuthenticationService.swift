//
//  AuthenticationService.swift
//  Bangerify
//
//  Created by David Kasperek on 16/03/2023.
//

import Foundation
import Combine
import SwiftKeychainWrapper

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
    private var accessToken: String?
    
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
                            print(tokenResponse)
                            self.accessToken = tokenResponse.accessToken
                            self.storeRefreshToken(tokenResponse.refreshToken)
                            completion(.success(tokenResponse.refreshToken))
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
    
    func getAccessToken() -> String? {
        return accessToken
    }
    
    func storeRefreshToken(_ token: String) {
        keychain.set(token, forKey: "refreshToken")
        isAuthenticated = true
    }
    
    func getRefreshToken() -> String? {
        return keychain.string(forKey: "refreshToken")
    }
    
    func clearToken() {
        keychain.removeObject(forKey: "refreshToken")
        isAuthenticated = false
    }
}
