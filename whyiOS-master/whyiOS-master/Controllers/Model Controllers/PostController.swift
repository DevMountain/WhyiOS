//
//  PostController.swift
//  whyiOS
//
//  Created by Eric Lanza on 12/11/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

class PostController {
    
    static let baseURL = URL(string: "https://whydidyouchooseios.firebaseio.com/reasons")
    
    static func fetchPosts(completion: @escaping ([Post]?) -> Void ) {
        guard let unwrappedURL = baseURL else { completion(nil); return }
        
        let getterEndpoint = unwrappedURL.appendingPathComponent(".json")
        
        var request = URLRequest(url: getterEndpoint)
        
        request.httpMethod = "GET"
        request.httpBody = nil
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print(error)
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No Data found from fetch posts")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedDictionary = try decoder.decode([String:Post].self, from: data)
                let decodedPosts = decodedDictionary.compactMap( { $0.value })
                completion(decodedPosts)
            } catch {
                print(error)
                completion(nil)
                return
            }
        }.resume()
    }
    
    static func postReason(name: String, reason: String, cohort: String, completion: @escaping (Bool) -> Void) {
        guard var unwrappedURL = baseURL else { completion(false); return }
        unwrappedURL.appendPathComponent(".json")
        let newPost = Post(name: name, reason: reason, cohort: cohort)
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(newPost)
            var request = URLRequest(url: unwrappedURL)
            request.httpMethod = "POST"
            request.httpBody = data
            
            URLSession.shared.dataTask(with: request) { (data, _, error) in
                if let error = error {
                    print("Error POSTing to API: \(error)")
                    completion(false)
                    return
                }
                if data != nil {
                    completion(true)
                    return
                }
                completion(false)
            }.resume()
        } catch {
            print("Error encoding post: \(error)")
            completion(false)
            return
        }
        
    }
}
