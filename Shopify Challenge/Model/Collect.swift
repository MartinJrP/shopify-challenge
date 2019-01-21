//
//  Collect.swift
//  Shopify Challenge
//
//  Created by Martin Jr Powlette on 2019-01-20.
//  Copyright © 2019 Martin Jr Powlette. All rights reserved.
//

import Foundation

struct Collect: Codable {
    let id: Int
    let lastUpdatedDate: Date
    let creationDate: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "product_id"
        case lastUpdatedDate = "updated_at"
        case creationDate = "created_at"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let creationDateString = try container.decode(String.self, forKey: .creationDate)
        let lastUpdatedDateString = try container.decode(String.self, forKey: .lastUpdatedDate)
        
        let dateFormatter = ISO8601DateFormatter()
        guard
            let creationDate = dateFormatter.date(from: creationDateString),
            let lastUpdatedDate = dateFormatter.date(from: lastUpdatedDateString)
            else {
                let context = DecodingError.Context(codingPath: [CodingKeys.creationDate, CodingKeys.lastUpdatedDate], debugDescription: "Invalid date formats.")
                throw DecodingError.dataCorrupted(context)
        }
        
        // Ensure updated date is less than published date as a means of integrity validation.
        guard creationDate <= lastUpdatedDate else {
            let context = DecodingError.Context(codingPath: [CodingKeys.creationDate, CodingKeys.lastUpdatedDate], debugDescription: "Invalid dates.")
            throw DecodingError.dataCorrupted(context)
        }
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.lastUpdatedDate = lastUpdatedDate
        self.creationDate = creationDate
    }
}
