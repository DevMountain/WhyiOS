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
    
    // BLACK DIAMOND: There is a lot happening in this function. If you couldn't figure it out on your own, don't feel bad. Look through the function and try to understand what is happening as it goes along. If our app was originally designed to handle deleting, this many network calls wouldn't be required in a delete function. Because firebase saves each "Post" under a UUID, we need to GET that UUID so we know which endpoint to delete. After we are able to find the endpoint, we can then send our completed DELETE network call to remove the correct Post.
    static func delete(post: Post, completion: @escaping (Bool) -> Void) {
        var deleteEndPoint = ""
        
        guard let unwrappedURL = baseURL else { completion(false); return }
        var components = URLComponents(url: unwrappedURL, resolvingAgainstBaseURL: true)
        
        let nameOrderQueryItem = URLQueryItem(name: "orderBy", value: "\"name\"")
        let equalToNameQueryItem = URLQueryItem(name: "equalTo", value: "\"\(post.name)\"")
        
        components?.queryItems = [nameOrderQueryItem, equalToNameQueryItem]
        
        guard var componentsURL = components?.url else { completion(false); return }
        componentsURL.appendPathExtension("json")
        
        URLSession.shared.dataTask(with: componentsURL) { (data, _, error) in
            if let error = error {
                print("Error fetching from API to delete: \(error)")
                completion(false)
                return
            }
            
            guard let data = data else { completion(false); return }
            
            do {
                let returnDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                let dictionaryAsPost = returnDictionary as? [String: [String: Any]]
                let filteredDictionary = dictionaryAsPost?.filter({ (arg) -> Bool in
                    
                    let (_, value) = arg
                    return value["cohort"] as? String == post.cohort && value["reason"] as? String == post.reason
                })
                deleteEndPoint = filteredDictionary?.first?.key ?? ""
            } catch {
                print("Error decoding JSON on delete function: \(error)")
                completion(false)
                return
            }
            
            guard var deleteUnwrappedURL = baseURL else { completion(false); return }
            
            if deleteEndPoint == "error" || deleteEndPoint == "" {
                completion(false)
                return
            }
            deleteUnwrappedURL.appendPathComponent(deleteEndPoint)
            deleteUnwrappedURL.appendPathExtension("json")
            
            var request = URLRequest(url: deleteUnwrappedURL)
            request.httpMethod = "DELETE"
            
            URLSession.shared.dataTask(with: request) { (data, _, error) in
                if let error = error {
                    print("Error DELETEing to API: \(error)")
                    completion(false)
                    return
                }
                if data != nil {
                    completion(true)
                    return
                }
                completion(false)
            }.resume()
        }.resume()
    }
}

