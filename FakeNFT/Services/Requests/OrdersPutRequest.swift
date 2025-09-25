//
//  OrdersPutRequest.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 16.09.2025.
//

import Foundation

struct OrdersPutRequest: NetworkRequest {
    let httpMethod: HttpMethod = .put
    let orders: Set<String>
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    
    var body: RequestBodyConvertible? {
        OrdersRequestBody(orders: orders)
    }
    
    init(orders: Set<String>) {
        self.orders = orders
    }
}

struct OrdersRequestBody: RequestBodyConvertible {
    let orders: Set<String>
    
    func asDictionary() -> [String: String] {
        if orders.isEmpty {
            return ["nfts": "null"]
        } else {
            return ["nfts": orders.joined(separator: ",")]
        }
    }
    
    func asJSONData() -> Data? {
        return nil
    }
    
    var contentType: String {
        return "application/x-www-form-urlencoded"
    }
}
