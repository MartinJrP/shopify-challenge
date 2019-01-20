//
//  DownloadManager.swift
//  Shopify Challenge
//
//  Created by Martin Jr Powlette on 2019-01-20.
//  Copyright © 2019 Martin Jr Powlette. All rights reserved.
//

import Foundation

class DownloadManager {
    
    let session: URLSession
    
    init() {
        session = URLSession.init(configuration: .default)
    }
    
    public func fetchCustomCollections(completion: @escaping ([CustomCollection]?, Error?) -> Void) {
        let customCollectionUrl = URL(string: "https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6")!
        
        session.dataTask(with: customCollectionUrl) { (data, response, error) in
            
            do {
                try self.handleErrorIfAny(error: error)
                try self.validate(response: response)
                
                let decoder = JSONDecoder()
                let structuredResponse = try decoder.decode(CustomCollectionResponse.self,
                                                            from: try self.validated(data: data))
                
                completion(structuredResponse.collections, nil)
            } catch {
                completion(nil, error)
            }
            
        }.resume()
    }
    
    private func validate(response: URLResponse?) throws {
        let response = response as! HTTPURLResponse
        guard response.statusCode == 200 else {
            throw DownloadManagerError.serverError
        }
    }
    
    private func validated(data: Data?) throws -> Data {
        guard let data = data else {
            throw DownloadManagerError.serverError
        }
        
        return data
    }
    
    private func handleErrorIfAny(error: Error?) throws {
        guard error == nil else {
            throw error!
        }
    }
}

enum DownloadManagerError: Error {
    case serverError
    case dataNotReceived
}

struct CustomCollectionResponse: Codable {
    let collections: [CustomCollection]
    
    enum CodingKeys: String, CodingKey {
        case collections = "custom_collections"
    }
}

