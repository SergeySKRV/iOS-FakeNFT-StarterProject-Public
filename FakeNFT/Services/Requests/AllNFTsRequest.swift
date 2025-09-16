//
//  AllNFTsRequest.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 10.09.2025.
//

import Foundation

// MARK: - AllNFTsRequest
struct AllNFTsRequest: NetworkRequest {
    // MARK: - NetworkRequest Properties
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft")
    }

    var httpMethod: HttpMethod = .get
    var dto: Dto?
}
