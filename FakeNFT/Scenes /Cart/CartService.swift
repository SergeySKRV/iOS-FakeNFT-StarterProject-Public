//import Foundation
//
//final class CartService: CartServiceProtocol {
//    private let networkClient: NetworkClient
//    private let cartEndpoint = "https://example.com/api/v1/cart"
//    
//    init(networkClient: NetworkClient = DefaultNetworkClient()) {
//        self.networkClient = networkClient
//    }
//    
//    func loadCartItems(completion: @escaping (Result<[CartItem], Error>) -> Void) {
//        let request = NetworkRequest(
//            endpoint: URL(string: cartEndpoint),
//            httpMethod: .get
//        )
//        
//        networkClient.send(request: request, type: CartResponse.self) { result in
//            switch result {
//            case .success(let cartResponse):
//                completion(.success(cartResponse.items))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    func deleteItemFromCart(itemId: String, completion: @escaping (Result<Void, Error>) -> Void) {
//        let deleteRequest = DeleteCartItemRequest(itemId: itemId)
//        let request = NetworkRequest(
//            endpoint: URL(string: "\(cartEndpoint)/item"),
//            httpMethod: .delete,
//            dto: deleteRequest
//        )
//        
//        networkClient.send(request: request) { result in
//            switch result {
//            case .success:
//                completion(.success(()))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    func proceedToPayment(completion: @escaping (Result<PaymentResponse, Error>) -> Void) {
//        let request = NetworkRequest(
//            endpoint: URL(string: "\(cartEndpoint)/payment"),
//            httpMethod: .post
//        )
//        
//        networkClient.send(request: request, type: PaymentResponse.self) { result in
//            completion(result)
//        }
//    }
//}

import Foundation

final class CartService: CartServiceProtocol {
    func loadCartItems(completion: @escaping (Result<[CartItem], Error>) -> Void) {
        let testItems = [
            CartItem(id: "1", name: "April", image: "april_image", rating: 4, price: 1.78, currency: "ETH"),
            CartItem(id: "2", name: "Greena", image: "greena_image", rating: 5, price: 1.78, currency: "ETH"),
            CartItem(id: "3", name: "Spring", image: "spring_image", rating: 6, price: 1.78, currency: "ETH")
        ]
        completion(.success(testItems))
    }
    
    func deleteItemFromCart(itemId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print("Удаление элемента \(itemId) (заглушка)")
        completion(.success(()))
    }
    
    func proceedToPayment(completion: @escaping (Result<PaymentResponse, Error>) -> Void) {
        print("Оплата (заглушка)")
        let response = PaymentResponse(success: true, orderId: "123", error: nil)
        completion(.success(response))
    }
}
