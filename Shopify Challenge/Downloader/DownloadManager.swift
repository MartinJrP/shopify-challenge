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
        
        download(CustomCollectionResponse.self, at: customCollectionUrl) { (response, error) in
            completion(response?.collections, error)
        }
    }
    
    public func fetchProducts(for collectionId: Int, completion: @escaping ([Product]?, Error?) -> Void) {
        
        fetchCollects(for: collectionId) { (collects, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            let productIds = collects!.map({ $0.id.description })
            let queryItems = [
                URLQueryItem(name: "ids", value: productIds.joined(separator: ",")),
                URLQueryItem(name: "page", value: "1"),
                URLQueryItem(name: "access_token", value: "c32313df0d0ef512ca64d5b336a0d7c6")
            ]
            var baseURL = URLComponents(string: "https://shopicruit.myshopify.com/admin/products.json")!
            baseURL.queryItems = queryItems
            
            let productsUrl = baseURL.url!
            
            self.download(ProductResponse.self, at: productsUrl) { (response, error) in
                completion(response?.products, error)
            }
        }
    }
    
    private func fetchCollects(for collectionId: Int, completion: @escaping ([Collect]?, Error?) -> Void) {
        let queryItems = [
            URLQueryItem(name: "collection_id", value: collectionId.description),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "access_token", value: "c32313df0d0ef512ca64d5b336a0d7c6")
        ]
        var baseURL = URLComponents(string: "https://shopicruit.myshopify.com/admin/collects.json")!
        baseURL.queryItems = queryItems
        
        let collectUrl = baseURL.url!
        
        download(CollectResponse.self, at: collectUrl) { (response, error) in
            completion(response?.collects, error)
        }
        
    }
    
    
    // MARK: - Private Helpers
    
    private func download<T: APIResponding>(_ ResponseType: T.Type, at url: URL, then completion: @escaping (T?, Error?) -> Void)  {
        
        session.dataTask(with: url) { (data, response, error) in
            
            do {
                try self.handleErrorIfAny(error: error)
                try self.validate(response: response)
                
                let decoder = JSONDecoder()
                let structuredResponse = try decoder.decode(ResponseType,
                                                            from: try self.validated(data: data))
                
                completion(structuredResponse, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    /// Ensures the response recieved was valid.
    private func validate(response: URLResponse?) throws {
        let response = response as! HTTPURLResponse
        guard response.statusCode == 200 else {
            throw DownloadManagerError.serverError
        }
    }
    
    /// Ensures the data downloaded is valid and returns the same data, unwrapped.
    private func validated(data: Data?) throws -> Data {
        guard let data = data else {
            throw DownloadManagerError.serverError
        }
        
        return data
    }
    
    /// Handles any errors raised by the request.
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

protocol APIResponding: Decodable {
    //var data: [Self] { get }
}


struct CustomCollectionResponse: APIResponding {
    let collections: [CustomCollection]
    
    enum CodingKeys: String, CodingKey {
        case collections = "custom_collections"
    }
}

struct CollectResponse: APIResponding {
    let collects: [Collect]
}

struct ProductResponse: APIResponding {
    let products: [Product]
}
