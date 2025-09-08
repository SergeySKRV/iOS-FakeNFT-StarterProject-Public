import Foundation

protocol CartServiceProtocol {
    func loadCartItems(completion: @escaping (Result<[CartItem], Error>) -> Void)
    func deleteItemFromCart(itemId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func proceedToPayment(completion: @escaping (Result<PaymentResponse, Error>) -> Void)
}
