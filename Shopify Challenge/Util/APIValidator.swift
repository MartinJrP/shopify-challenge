//
//  APIValidator.swift
//  Shopify Challenge
//
//  Created by Martin Jr Powlette on 2019-01-20.
//  Copyright © 2019 Martin Jr Powlette. All rights reserved.
//

import Foundation

class ResponseDecodingValidator<T: CodingKey> {
    let container: KeyedDecodingContainer<T>
    
    init(container: KeyedDecodingContainer<T>) {
        self.container = container
    }
    
    public func date(from dateString: String) throws -> Date {
        
        let dateFormatter = ISO8601DateFormatter()
        guard let date = dateFormatter.date(from: dateString) else {
            let context = DecodingError.Context(codingPath: container.codingPath, debugDescription: "Invalid date format.")
            throw DecodingError.dataCorrupted(context)
        }
        
        return date
    }
    
    /// Ensure updated date is less than published date as a means of integrity validation.
    public func validate(creationDate: Date, lastUpdatedDate: Date) throws {
        guard creationDate <= lastUpdatedDate else {
            let context = DecodingError.Context(codingPath: container.codingPath, debugDescription: "Invalid dates.")
            throw DecodingError.dataCorrupted(context)
        }
    }
    
}
