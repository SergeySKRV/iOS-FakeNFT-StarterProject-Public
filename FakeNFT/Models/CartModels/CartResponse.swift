import Foundation

struct CartResponse: Decodable {
    let id: String?
    let nfts: [String]?
    let totalPrice: Float?
}

struct NFTDetailResponse: Decodable {
    let id: String
    let name: String
    let images: [String]
    let rating: Int
    let price: Float
}

