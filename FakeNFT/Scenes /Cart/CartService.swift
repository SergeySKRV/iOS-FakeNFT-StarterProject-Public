import Foundation

final class CartService: CartServiceProtocol {
    private let networkClient: StatisticsNetworkClient
    private let baseURL = RequestConstants.baseURL
    
    private var currentNFTIds: [String] = []
    
    init(networkClient: StatisticsNetworkClient) {
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
        
        networkClient.send(request: request, type: CartResponse.self) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let cartResponse):
                let nftIds = cartResponse.nfts ?? []
                self.currentNFTIds = nftIds
                self.loadNFTDetails(nftIds: nftIds, completion: completion)
            case .failure(let error):
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
        let updatedNFTs = currentNFTIds.filter { $0 != itemId }
        
        updateOrder(nfts: updatedNFTs) { [weak self] result in
            switch result {
            case .success:
                self?.currentNFTIds = updatedNFTs
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func updateOrder(nfts: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        let urlString = "\(baseURL)/api/v1/orders/1"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("45c5b907-7b41-4702-bced-d61034c05bae", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        var components = URLComponents()
        
        if nfts.isEmpty {
            request.httpBody = nil
        } else {
            components.queryItems = nfts.map { nftId in
                URLQueryItem(name: "nfts", value: nftId)
            }
            
            if let queryString = components.percentEncodedQuery {
                request.httpBody = queryString.data(using: .utf8)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                completion(.success(()))
            } else {
                let error = NSError(
                    domain: "",
                    code: httpResponse.statusCode,
                    userInfo: [NSLocalizedDescriptionKey: "HTTP Error: \(httpResponse.statusCode)"]
                )
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func loadCurrencies(completion: @escaping (Result<[Currency], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/v1/currencies") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let request = CartNetworkRequest(endpoint: url, httpMethod: .get)
        
        networkClient.send(request: request, type: [Currency].self) { result in
            completion(result)
        }
    }
    
    func proceedToPayment(currencyId: String, completion: @escaping (Result<PaymentResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/v1/orders/1/payment/\(currencyId)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let request = CartNetworkRequest(endpoint: url, httpMethod: .get)
        
        networkClient.send(request: request, type: PaymentResponse.self) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let paymentResponse):
                if paymentResponse.success {
                    self.clearCartAfterPayment()
                    completion(.success(paymentResponse))
                } else {
                    let error = NSError(
                        domain: "PaymentError",
                        code: 0,
                        userInfo: [NSLocalizedDescriptionKey: "Payment failed"]
                    )
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func clearCartAfterPayment() {
        updateOrder(nfts: []) { result in
            switch result {
            case .success:
                self.currentNFTIds = []
            case .failure:
                break
            }
        }
    }
}

