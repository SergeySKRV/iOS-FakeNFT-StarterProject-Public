//
//  UserRequest.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 17.09.2025.
//

import Foundation

struct UserRequest: NetworkRequest {
    let id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users/\(id)")
    }
}
