//
//  OrdersPutRequest.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 16.09.2025.
//

import Foundation

struct OrdersPutRequest: NetworkRequest {
    // MARK: - Public Properties
    let httpMethod: HttpMethod = .put
    
    var id: String
    var orders: Set<String>
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    var body: Data? {
        return ordersToString().data(using: .utf8)
    }
    
    // MARK: - Initializers
    init(id: String, orders: Set<String>) {
        self.orders = orders
        self.id = id
    }

    // MARK: - Public Methods
    func ordersToString() -> String {
        var ordersString = "nfts="
        
        if orders.isEmpty {
            ordersString += ""
        } else {
            for (index , order) in orders.enumerated() {
                ordersString += order
                if index != orders.count - 1 {
                    ordersString += "&nfts="
                }
            }
        }
        ordersString += "&id=\(id)"
        return ordersString
    }
}
