//
//  CatalogStorage.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 16.09.2025.
//

import Foundation

protocol CatalogStorageProtocol: AnyObject {
    var likes: Set<String> { get set }
    var orders: Set<String> { get set }
    var orderId: String? { get }
    func saveNft(_ nft: String)
    func getNft(with id: String) -> String?
    func saveOrderId(orderId: String)
    func saveOrders(_ nft: String)
    func findInOrders(_ nft: String) -> Bool
}

final class CatalogStorage: CatalogStorageProtocol {
    // MARK: - Public Properties
    var likes: Set<String> = []
    var orders: Set<String> = []
    var orderId: String?
    
    // MARK: - Private Properties
    private let syncQueue = DispatchQueue(label: "sync-nft-queue")
    
    // MARK: - Public Methods
    func saveNft(_ nft: String) {
        syncQueue.async { [weak self] in
            self?.likes.insert(nft)
        }
    }
    
    func getNft(with id: String) -> String? {
        syncQueue.sync {
            likes.first(where: { $0 == id })
        }
    }
    
    func saveOrderId(orderId: String) {
        syncQueue.async { [weak self] in
            self?.orderId = orderId
        }
    }
    
    func saveOrders(_ nft: String) {
        syncQueue.async { [weak self] in
            self?.orders.insert(nft)
        }
    }
    
    func findInOrders(_ nft: String) -> Bool {
        orders.contains(nft)
    }
}

