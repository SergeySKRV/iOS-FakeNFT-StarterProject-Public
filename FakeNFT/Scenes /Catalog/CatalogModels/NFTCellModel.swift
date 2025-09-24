//
//  NFTCellModel.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 01.09.2025.
//

import Foundation

struct NFTCellModel {
    let id: String
    let name: String
    let image: URL?
    let rating: Int
    let isLiked: Bool
    let isInCart: Bool
    let price: Float
}
