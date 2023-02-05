//
//  ProfileService.swift
//  Bangerify
//
//  Created by David Kasperek on 05/02/2023.
//

import Foundation

class ProfileService { // TODO: Check if could be improved - after using closures
    
    static let shared = ProfileService()
    
    func loadProfile(username: String, completion: @escaping (Profile?) -> Void) {
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
                        let profileArray = try JSONDecoder().decode([Profile].self, from: data)
                        let profile = profileArray.first!
                        completion(profile)
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
}
