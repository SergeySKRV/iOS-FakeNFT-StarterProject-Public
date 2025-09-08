import Foundation

struct CartResponse: Decodable {
    let items: [CartItem]
    let totalPrice: Double
}
