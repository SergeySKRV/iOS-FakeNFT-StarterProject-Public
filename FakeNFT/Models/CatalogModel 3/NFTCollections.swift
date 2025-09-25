//
//  NFTCollections.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 31.08.2025.
//

import Foundation

struct NFTCollection: Codable {
    let createdAt: String
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    let id: String
}
