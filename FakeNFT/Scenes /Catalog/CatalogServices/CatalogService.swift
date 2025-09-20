//
//  CatalogService.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 31.08.2025.
//
import Foundation

protocol CatalogServiceProtocol: AnyObject {
    func getNftCollections(completion: @escaping (Result<[NFTCollection], Error>) -> Void)
    func getNFTs(id: String, completion: @escaping (Result<NFTs, Error>) -> Void)
    func getAuthorNftCollection(id: String, completion: @escaping (UserModel) -> Void)
    func getProfile(completion: @escaping (Result<ProfileResult, Error>) -> Void)
    func putProfile(id: String, completion: @escaping (Result<ProfileResult, Error>) -> Void)
    func likeStatus(_ id: String) -> Bool
    func getOrders(completion: @escaping (Result<OrdersResult, Error>) -> Void)
    func putOrders(id: String, completion: @escaping (Result<OrdersResult, Error>) -> Void)
    func orderStatus(_ id: String) -> Bool
}


final class CatalogService: CatalogServiceProtocol {
    // MARK: - Private Properties
    private let networkClient: DefaultNetworkClient
    private let catalogStorage: CatalogStorageProtocol
    
    // MARK: - Initializers
    init(networkClient: DefaultNetworkClient, catalogStorage: CatalogStorageProtocol) {
        self.networkClient = networkClient
        self.catalogStorage = catalogStorage
    }
    
    // MARK: - Public Methods
    func getNftCollections(completion: @escaping (Result<[NFTCollection], any Error>) -> Void) {
        let request = NFTCollectionsRequest()
        networkClient.send(
            request: request,
            type: [NFTCollection].self) { result in
                switch result {
                case .success(let collections):
                    completion(.success(collections))
                case .failure(let error):
                    if let networkError = error as? NetworkClientError {
                        completion(.failure(networkError))
                    } else {
                        completion(.failure(error))
                    }
                }
            }
    }
    
    func getNFTs(id: String, completion: @escaping (Result<NFTs, Error>) -> Void) {
        let request = NFTRequest(id: id)
        networkClient.send(request: request,
                           type: NFTs.self) { result in
            switch result {
            case .success(let nft):
                completion(.success(nft))
            case .failure(let error):
                if let networkError = error as? NetworkClientError {
                    completion(.failure(networkError))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getAuthorNftCollection(id: String, completion: @escaping (UserModel) -> Void) {
        let request = UserRequest(id: id)
        networkClient.send(request: request,
                           type: UserResult.self) { result in
            switch result {
            case .success(let data):
                completion((UserModel(with: data)))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getProfile(completion: @escaping (Result<ProfileResult, Error>) -> Void) {
        let request = ProfileRequest()
        networkClient.send(request: request,
                           type: ProfileResult.self) { [weak self] result in
            switch result {
            case .success(let profile):
                if !profile.likes.isEmpty {
                    profile.likes.forEach {
                        self?.catalogStorage.saveNft($0)
                    }
                }
                completion(.success(profile))
            case .failure(let error):
                if let networkError = error as? NetworkClientError {
                    completion(.failure(networkError))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func putProfile(id: String, completion: @escaping (Result<ProfileResult, Error>) -> Void) {
        var likes = catalogStorage.likes
        if let _ = catalogStorage.getNft(with: id) {
            likes.remove(id)
        } else {
            likes.insert(id)
        }
        let request = ProfilePutRequest(likes: likes)
        networkClient.send(request: request, type: ProfileResult.self) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.catalogStorage.likes.removeAll()
                if !profile.likes.isEmpty {
                    profile.likes.forEach {
                        self?.catalogStorage.saveNft($0)
                    }
                }
                completion(.success(profile))
            case .failure(let error):
                if let networkError = error as? NetworkClientError {
                    completion(.failure(networkError))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func likeStatus(_ id: String) -> Bool {
        catalogStorage.getNft(with: id) != nil
    }
    
    func getOrders(completion: @escaping (Result<OrdersResult, Error>) -> Void) {
        let request = OrdersRequest()
        networkClient.send(request: request, type: OrdersResult.self) { [weak self] result in
            switch result {
            case .success(let orders):
                self?.catalogStorage.saveOrderId(orderId: orders.id)
                if !orders.nfts.isEmpty{
                    orders.nfts.forEach{
                        self?.catalogStorage.saveOrders($0)
                    }
                }
                completion(.success(orders))
            case .failure(let error):
                if let networkError = error as? NetworkClientError {
                    completion(.failure(networkError))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    
    func putOrders(id: String, completion: @escaping (Result<OrdersResult, Error>) -> Void) {
        var orders = catalogStorage.orders
        if catalogStorage.findInOrders(id) {
            orders.remove(id)
        } else {
            orders.insert(id)
        }
        let request = OrdersPutRequest(id: catalogStorage.orderId ?? "", orders: orders)
        networkClient.send(request: request, type: OrdersResult.self) { [weak self] result in
            switch result {
            case .success(let orders):
                self?.catalogStorage.saveOrderId(orderId: orders.id)
                self?.catalogStorage.orders.removeAll()
                if !orders.nfts.isEmpty{
                    orders.nfts.forEach{
                        self?.catalogStorage.saveOrders($0)
                    }
                }
                completion(.success(orders))
            case .failure(let error):
                if let networkError = error as? NetworkClientError {
                    completion(.failure(networkError))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
  
    func orderStatus(_ id: String) -> Bool {
        catalogStorage.findInOrders(id)
    }
}
