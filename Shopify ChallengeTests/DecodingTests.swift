//
//  DecodingTests.swift
//  Shopify ChallengeTests
//
//  Created by Martin Jr Powlette on 2019-01-20.
//  Copyright © 2019 Martin Jr Powlette. All rights reserved.
//

import XCTest
@testable import Shopify_Challenge

class CustomCollectionDecodingTests: XCTestCase {

    func testCanRawResponse() {
        let customCollectionJSON = """
        {
            "custom_collections": [
                {
                    "id": 68424466488,
                    "handle": "aerodynamic-collection",
                    "title": "Aerodynamic collection",
                    "updated_at": "2018-12-17T13:51:58-05:00",
                    "body_html": "The top of the line of aerodynamic products all in the same collection.",
                    "published_at": "2018-12-17T13:50:07-05:00",
                    "sort_order": "best-selling",
                    "template_suffix": "",
                    "published_scope": "web",
                    "admin_graphql_api_id": "gid://shopify/Collection/68424466488",
                    "image": {
                        "created_at": "2018-12-17T13:51:57-05:00",
                        "alt": null,
                        "width": 300,
                        "height": 300,
                        "src": "https://cdn.shopify.com/s/files/1/1000/7970/collections/Aerodynamic_20Cotton_20Keyboard_grande_b213aa7f-9a10-4860-8618-76d5609f2c19.png?v=1545072718"
                    }
                }]
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        XCTAssertNoThrow(try decoder.decode(CustomCollectionResponse.self, from: customCollectionJSON))
    }
    
    func testWillFailIfURLIsInvalid() {
        let imageJSON = """
        {
        "created_at": "2018-12-17T13:51:57-05:00",
        "alt": null,
        "width": 300,
        "height": 300,
        "src": "https://invalid.url.com/s/files/1/1000/7970/collections/Aerodynamic_20Cotton_20Keyboard_grande_b213aa7f-9a10-4860-8618-76d5609f2c19.png?v=1545072718"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(CustomCollection.Image.self, from: imageJSON)
        } catch DecodingError.dataCorrupted(let context) {
            let expectedErrorDescription = "Invalid host address. Found invalid.url.com but expected shopify.com"
            XCTAssertEqual(expectedErrorDescription, context.debugDescription)
        } catch {
            XCTFail("Unexpected Error: \(error)")
        }
    }

}
