//
//  OrdersRequest.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 15.09.2025.
//

import Foundation

struct OrdersRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}
