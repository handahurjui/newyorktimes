//
//  Article.swift
//  NewYorkTimes
//
//  Created by anda hurjui on 25/09/2018.
//  Copyright © 2018 programmer. All rights reserved.
//

import Foundation

struct PostsResponse : Codable {
    
    let results: [Post]
    
    init(from decoder:Decoder) throws {
        let codingContainer = try decoder.container(keyedBy: CodingKeys.self)

        results = try codingContainer.decode([Post].self, forKey: .results)
        
    }
    
}
    public enum PostType: String {
        case mostemailed
        case mostshared
        case mostviewed

    }
    public enum PostTimePeriod: Int {
        case day = 1
        case week = 7
        case month = 30

    }
struct Post : Codable {
    
    let title : String
    let section: String?
    let abstract: String?
    let url: URL?
    let published_date: Date

}
extension DateFormatter {
    
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    static let MMddyyyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
}
extension Post {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        section = try container.decode(String.self, forKey: .section)
        abstract = try container.decode(String.self, forKey: .abstract)
        url = try container.decode(URL.self, forKey: .url)
        let dateString = try container.decode(String.self, forKey: .published_date)
        let formatter = DateFormatter.yyyyMMdd
        if let date = formatter.date(from: dateString) {
            published_date = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .published_date, in: container, debugDescription: "Date string does not match format expected by formatter.")
        }
    }
}
