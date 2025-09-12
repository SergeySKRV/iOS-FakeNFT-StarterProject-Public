//
//  NFTs.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 01.09.2025.
//

import Foundation

struct NFTs: Decodable {
    let createdAt: String
    let name: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let id: String
}
