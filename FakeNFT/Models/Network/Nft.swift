import Foundation

// MARK: - Nft
struct Nft: Decodable {
    
    // MARK: - Properties
    let id: String
    let name: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let createdAt: String
}
