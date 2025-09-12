import Foundation

struct CartItem: Decodable {
    let id: String
    let name: String
    let image: String
    let rating: Int
    let price: Double
    let currency: String
}
