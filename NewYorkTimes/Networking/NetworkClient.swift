//
//  NetworkingClient.swift
//  NewYorkTimes
//
//  Created by anda hurjui on 25/09/2018.
//  Copyright © 2018 programmer. All rights reserved.
//

import Foundation

public final class NetworkClient {
    
    fileprivate let baseURL: URL
    fileprivate let session = URLSession.shared
    fileprivate let apiKey : String
    
    // MARK: - Class Constructors
    public static let shared: NetworkClient = {
        let file = Bundle.main.path(forResource: "ServerDetails", ofType: "plist")!
        let dictionary = NSDictionary(contentsOfFile: file)!
        let urlString = dictionary["service_url"] as! String
        let key = dictionary["api_key"] as! String
        let url = URL(string: urlString)!
        return NetworkClient(baseURL: url, apiKey: key)
    }()
    
    // MARK: - Object Lifecycle
    private init( baseURL: URL, apiKey: String) {
        self.baseURL = baseURL
        self.apiKey = apiKey
    }
    // MARK: - Post
     func getPosts(forType type: PostType = PostType.mostviewed,
                         forSection section: String = "all-sections",
                         forTimePeriod period: Int,
                            success _success: @escaping ([Post]) -> Void,
                            failure _failure: @escaping (String) -> Void){
        
        let success: ([Post]) -> Void = { products in
            DispatchQueue.main.async { _success(products) }
        }
        let failure: (String) -> Void = { error in
            DispatchQueue.main.async { _failure(error) }
        }
        
        
        let url = baseURL.appendingPathComponent("\(type.rawValue)/\(section)/\(period).json")
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["api-key":"\(apiKey)"]

        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let data = data else {
                    if let error = error {
                        failure("Network error: \(error.localizedDescription)")
                    } else {
                        failure("Response error: \(error?.localizedDescription)")
                    }
                    return
            }
           
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let posts = try! decoder.decode(PostsResponse.self, from: data)

                success(posts.results)
            } catch {
                NSLog("Error parsing posts: \(error.localizedDescription)")
            }
            
        }
        
        task.resume()
    }
    
    // MARK: - Section
    func getSections(forType type: PostType = PostType.mostviewed,
                  forSection section: String = "all-sections",
                  forTimePeriod period: Int = 30,
                  success _success: @escaping ([Section]) -> Void,
                  failure _failure: @escaping (String) -> Void){
        
        let success: ([Section]) -> Void = { sections in
            DispatchQueue.main.async { _success(sections) }
        }
        let failure: (String) -> Void = { error in
            DispatchQueue.main.async { _failure(error) }
        }
        
        
        let url = baseURL.appendingPathComponent("\(type.rawValue)/\(section)/\(period).json")
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["api-key":"\(apiKey)"]
        
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let data = data
                 else {
                    if let error = error {
                     
                        failure("Network error: \(error.localizedDescription)")
                    } else {
                       
                        failure("Response error: \(error?.localizedDescription) " + "\n")
                    }
                    return
            }
            
            let decoder = JSONDecoder()
            do {
                let sections = try! decoder.decode(SectionsResponse.self, from: data)
                success(sections.results)
            } catch {
                NSLog("Error parsing posts: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
