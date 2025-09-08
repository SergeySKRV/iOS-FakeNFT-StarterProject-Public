import Foundation

final class CartService: CartServiceProtocol {
    private let networkClient: NetworkClient
    private let baseURL = RequestConstants.baseURL
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func loadCartItems(completion: @escaping (Result<[CartItem], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/v1/orders/1") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let request = CartNetworkRequest(
            endpoint: url,
            httpMethod: .get
        )
        
        networkClient.send(request: request, type: CartResponse.self) { result in
            switch result {
            case .success(let cartResponse):
                let nftIds = cartResponse.nfts ?? []
                print("Загружено NFT: \(nftIds.count)")
                self.loadNFTDetails(nftIds: nftIds, completion: completion)
            case .failure(let error):
                print("Ошибка загрузки корзины: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    private func loadNFTDetails(nftIds: [String], completion: @escaping (Result<[CartItem], Error>) -> Void) {
        var nftItems: [CartItem] = []
        let group = DispatchGroup()
        
        for nftId in nftIds {
            group.enter()
            let request = CartNetworkRequest(
                endpoint: URL(string: "\(baseURL)/api/v1/nft/\(nftId)"),
                httpMethod: .get
            )
            
            networkClient.send(request: request, type: NFTDetailResponse.self) { result in
                defer { group.leave() }
                switch result {
                case .success(let nft):
                    let cartItem = CartItem(
                        id: nft.id,
                        name: nft.name,
                        image: nft.images.first ?? "",
                        rating: nft.rating,
                        price: Double(nft.price),
                        currency: "ETH"
                    )
                    nftItems.append(cartItem)
                case .failure(let error):
                    print("Ошибка загрузки NFT \(nftId): \(error)")
                }
            }
        }
        
        group.notify(queue: .main) {
            completion(.success(nftItems))
        }
    }
    
    func deleteItemFromCart(itemId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print("Удаление элемента \(itemId) (заглушка)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            completion(.success(()))
        }
    }
    // пока не реализовано
    
    //    func proceedToPayment(completion: @escaping (Result<PaymentResponse, Error>) -> Void) {
    //        let request = CartNetworkRequest(
    //            endpoint: URL(string: "\(baseURL)/orders/1/payment/1"),
    //            httpMethod: .get
    //        )
    //
    //        networkClient.send(request: request, type: PaymentResponse.self) { result in
    //            completion(result)
    //        }
    //    }
}
