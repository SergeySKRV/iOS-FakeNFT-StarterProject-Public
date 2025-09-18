//
//  UserLikesUpdateDTO.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 17.09.2025.
//

import Foundation

// MARK: - UserLikesUpdateDTO
struct UserLikesUpdateDTO: Dto {
    // MARK: - Properties
    let likes: [String]

    // MARK: - Public methods
    func asDictionary() -> [String: String] {
        if likes.isEmpty {
            return ["likes": "null"]
        } else {
            return ["likes": likes.joined(separator: ",")]
        }
    }

    func asJSONData() -> Data? { nil }

    var contentType: String { "application/x-www-form-urlencoded" }
}
