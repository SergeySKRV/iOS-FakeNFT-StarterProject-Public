//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 17.09.2025.
//

import Foundation

struct ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
}

