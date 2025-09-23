import Foundation

struct PaymentResponse: Decodable {
    let success: Bool
    let orderId: String?
    let id: String?
//    let error: String?
}
