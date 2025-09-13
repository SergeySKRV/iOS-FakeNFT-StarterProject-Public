//
//  UserProfileUpdateDTO.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 11.09.2025.
//

import Foundation

// MARK: - UserProfileUpdateDTO
struct UserProfileUpdateDTO: Dto {

    // MARK: - Properties
    let name: String?
    let description: String?
    let website: String?
    let avatar: String?

    // MARK: - Public Methods
    func asDictionary() -> [String: String] {
        var params: [String: String] = [:]
        
        if let name = self.name {
            params["name"] = name
        }
        if let description = self.description {
            params["description"] = description
        }
        if let website = self.website {
            params["website"] = website
        }
        if let avatar = self.avatar {
            params["avatar"] = avatar
        }
        return params
    }
}
