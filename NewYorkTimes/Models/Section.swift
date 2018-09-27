//
//  Section.swift
//  NewYorkTimes
//
//  Created by andah on 27/09/2018.
//  Copyright © 2018 programmer. All rights reserved.
//
import Foundation

struct SectionsResponse : Codable {
    let results: [Section]
    
    init(from decoder:Decoder) throws {
        let codingContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        results = try codingContainer.decode([Section].self, forKey: .results)
        
    }
    
    
}
struct Section : Codable {
    
    let section : String
}
