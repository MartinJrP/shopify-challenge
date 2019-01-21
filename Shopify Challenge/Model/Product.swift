//
//  Product.swift
//  Shopify Challenge
//
//  Created by Martin Jr Powlette on 2019-01-20.
//  Copyright © 2019 Martin Jr Powlette. All rights reserved.
//

import Foundation



struct Product: Decodable {
    
    typealias ID = Int
    
    let id: ID
    let title: String
    let totalQuantity: Int
    
    let lastUpdatedDate: Date
    let creationDate: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case lastUpdatedDate = "updated_at"
        case creationDate = "created_at"
        
        case variants
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let validator = ResponseDecodingValidator(container: container)
        
        let creationDateString = try container.decode(String.self, forKey: .creationDate)
        let lastUpdatedDateString = try container.decode(String.self, forKey: .lastUpdatedDate)
        let creationDate = try validator.date(from: creationDateString)
        let lastUpdatedDate = try validator.date(from: lastUpdatedDateString)
        
        try validator.validate(creationDate: creationDate, lastUpdatedDate: lastUpdatedDate)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.creationDate = creationDate
        self.lastUpdatedDate = lastUpdatedDate
        
        let variants = try container.decode([Variant].self, forKey: .variants)
        let totalQuantity: Int = variants.reduce(0) { $0 + $1.quantity }
        
        self.totalQuantity = totalQuantity
    }
}

extension Product {
    struct Variant: Codable {
        let id: Int
        let title: String
        let quantity: Int
        
        enum CodingKeys: String, CodingKey {
            case id
            case title
            case quantity = "inventory_quantity"
        }
    }
}
