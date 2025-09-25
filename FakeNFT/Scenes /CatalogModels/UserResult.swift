//
//  UserResult.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 17.09.2025.
//

import Foundation

struct UserResult: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
}
