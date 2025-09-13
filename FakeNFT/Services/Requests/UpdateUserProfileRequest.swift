//
//  UpdateUserProfileRequest.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 11.09.2025.
//

import Foundation

// MARK: - UpdateUserProfileRequest
struct UpdateUserProfileRequest: NetworkRequest {
    // MARK: - Properties
    private let profileId: String
    private let updateData: UserProfileUpdateDTO
    
    // MARK: - Initialization
    init(profileId: String = "1", updateData: UserProfileUpdateDTO) {
        self.profileId = profileId
        self.updateData = updateData
    }

    // MARK: - NetworkRequest Properties
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(profileId)")
    }
    
    var httpMethod: HttpMethod = .put
    
    var dto: Dto? {
        return updateData
    }
}
