//
//  CustomCollection.swift
//  Shopify Challenge
//
//  Created by Martin Jr Powlette on 2019-01-20.
//  Copyright © 2019 Martin Jr Powlette. All rights reserved.
//

import Foundation

/// Represents a user's custom collection.
/// - Note: This structures Codable conformance only extracts values needed by the app do maximize memory usage. It will not contain all the properties available from the Custom Collections API.
struct CustomCollection: Codable {
    let id: Int
    let title: String
    let description: String
    let image: Image
    
    let lastUpdatedDate: Date
    let publishedDate: Date
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let publishedDateString = try container.decode(String.self, forKey: .publishedDate)
        let lastUpdatedDateString = try container.decode(String.self, forKey: .lastUpdatedDate)
        
        let dateFormatter = ISO8601DateFormatter()
        guard
            let publishedDate = dateFormatter.date(from: publishedDateString),
            let lastUpdatedDate = dateFormatter.date(from: lastUpdatedDateString)
            else {
                let context = DecodingError.Context(codingPath: [CodingKeys.publishedDate, CodingKeys.lastUpdatedDate], debugDescription: "Invalid date formats.")
                throw DecodingError.dataCorrupted(context)
        }
        
        // Ensure updated date is less than published date as a means of integrity validation.
        guard publishedDate <= lastUpdatedDate else {
            let context = DecodingError.Context(codingPath: [CodingKeys.publishedDate, CodingKeys.lastUpdatedDate], debugDescription: "Invalid dates.")
            throw DecodingError.dataCorrupted(context)
        }
        
        self.lastUpdatedDate = lastUpdatedDate
        self.publishedDate = publishedDate
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.image = try container.decode(Image.self, forKey: .image)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description = "body_html"
        case image
        
        case lastUpdatedDate = "updated_at"
        case publishedDate = "published_at"
    }
}

extension CustomCollection {
    struct Image: Codable {
        
        let altText: String?
        let src: URL
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            // Perform URL validation to ensure response isn't corrupted and src is trusted.
            let url = try container.decode(URL.self, forKey: .src)
            guard url.host == "cdn.shopify.com" else {
                throw DecodingError.dataCorruptedError(forKey: .src, in: container, debugDescription: "Invalid host address. Found \(url.host ?? "nil") but expected shopify.com")
            }
            
            altText = try container.decodeIfPresent(String.self, forKey: .altText)
            src = url
        }
        
        enum CodingKeys: String, CodingKey {
            case altText = "alt"
            case src
        }
    }
}
