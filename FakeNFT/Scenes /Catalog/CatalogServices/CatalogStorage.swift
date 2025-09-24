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
    
    // MARK: - Public Methods
    func saveNft(_ nft: String) {
        likes.insert(nft)
    }
    
    func removeNft(_ nft: String) {
        likes.remove(nft)
    }
    
    func clearLikes() {
        likes.removeAll()
    }
    
    func getNft(with id: String) -> String? {
        likes.first(where: { $0 == id })
    }
    
    func saveOrderId(orderId: String) {
        self.orderId = orderId
    }
    
    func saveOrders(_ nft: String) {
        orders.insert(nft)
    }
    
    func removeOrder(_ nft: String) {
        orders.remove(nft)
    }
    
    func clearOrders() {
        orders.removeAll()
    }
    
    func findInOrders(_ nft: String) -> Bool {
        orders.contains(nft)
    }
}

