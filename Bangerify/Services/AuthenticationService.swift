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
    static let shared = AuthenticationService()
    private let keychain = KeychainWrapper.standard
    private var cancellables = Set<AnyCancellable>()
    
    private let tokenRefreshQueue = DispatchQueue(label: "tokenRefreshQueue")
    private let tokenRefreshSemaphore = DispatchSemaphore(value: 1)
    
    init() {
        isAuthenticated = keychain.string(forKey: "refreshToken") != nil
    }
    
    func login(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "http://144.24.165.119:8080/api/auth/login") else {
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
                            self.fetchUsername { fetchResult in
                                switch fetchResult {
                                case .success(let username):
                                    print("Fetched username: \(username)")
                                    self.isAuthenticated = true
                                    completion(.success(tokenResponse.accessToken))
                                case .failure(let fetchError):
                                    print("Failed to fetch username: \(fetchError.localizedDescription)")
                                    self.clearToken()
                                    completion(.failure(fetchError))
                                }
                            }
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
        guard let url = URL(string: "http://144.24.165.119:8080/api/auth/register") else {
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
        if let refreshToken = self.getRefreshToken() {
            let parameters = ["token": refreshToken]
            AF.request("http://144.24.165.119:8080/api/token/refresh", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseData { response in
                    if let data = response.data, let string = String(data: data, encoding: .utf8) {
                        print("Response content: \(string)")
                    }
                    switch response.result {
                    case .success(let data):
                        do {
                            let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                            self.storeAccessToken(tokenResponse.accessToken)
                            self.storeRefreshToken(tokenResponse.refreshToken)
                            print("Tokens refreshed")
                            completion(tokenResponse.accessToken)
                        } catch let decodingError {
                            print("Decoding error: \(decodingError.localizedDescription)")
                            completion(nil)
                        }
                        
                    case .failure(let error):
                        print("Error refreshing access token: \(error.localizedDescription)")
                        self.clearToken()
                        completion(nil)
                    }
                }
        } else {
            completion(nil)
        }
    }
    
    
    
    func getValidAccessToken(completion: @escaping (String?) -> Void) {
        tokenRefreshQueue.async {
            self.tokenRefreshSemaphore.wait()
            if let accessToken = self.getAccessToken() {
                do {
                    let jwt = try decode(jwt: accessToken)
                    let expirationDate = jwt.expiresAt
                    
                    if let expirationDate = expirationDate, expirationDate.compare(Date()) == .orderedDescending {
                        self.tokenRefreshSemaphore.signal()
                        completion(accessToken)
                    } else {
                        self.refreshAccessToken { refreshedAccessToken in
                            self.tokenRefreshSemaphore.signal()
                            completion(refreshedAccessToken)
                        }
                    }
                } catch {
                    self.refreshAccessToken { refreshedAccessToken in
                        self.tokenRefreshSemaphore.signal()
                        completion(refreshedAccessToken)
                    }
                }
            } else {
                completion(nil)
            }
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
    
    func fetchUsername(completion: @escaping (Result<String, Error>) -> Void) {
        getValidAccessToken { accessToken in
            guard let accessToken = accessToken else {
                print("Error getting valid access token")
                return
            }

            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]

            AF.request("http://144.24.165.119:8080/api/auth/isLogged", method: .get, headers: headers).responseDecodable(of: IsLoggedResponse.self) { response in
                switch response.result {
                case .success(let data):
                    if data.isLogged {
                        self.storeUsername(data.username)
                        completion(.success(data.username))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch username"])))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func storeUsername(_ username: String) {
        keychain.set(username, forKey: "username")
    }
    
    func getUsername() -> String? {
        return keychain.string(forKey: "username") ?? ""
    }
}
