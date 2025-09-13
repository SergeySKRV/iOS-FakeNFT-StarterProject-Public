//
//  UserProfileRequest.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 10.09.2025.
//

import Foundation

// MARK: - UserProfileRequest
struct UserProfileRequest: NetworkRequest {
    // MARK: - Properties
    private let profileId = "1"

    // MARK: - NetworkRequest Properties
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(profileId)")
    }
    
    var httpMethod: HttpMethod = .get
    var dto: Dto? = nil
}
