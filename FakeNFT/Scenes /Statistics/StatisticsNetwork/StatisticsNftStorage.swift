import Foundation

protocol StatisticsNftStorage: AnyObject {
    func saveNft(_ nft: StatisticsNft)
    func getNft(with id: String) -> StatisticsNft?
}

final class StatisticsNftStorageImpl: StatisticsNftStorage {
    private var storage: [String: StatisticsNft] = [:]

    private let syncQueue = DispatchQueue(label: "sync-nft-queue")

    func saveNft(_ nft: StatisticsNft) {
        syncQueue.async { [weak self] in
            self?.storage[nft.id ?? ""] = nft
        }
    }

    func getNft(with id: String) -> StatisticsNft? {
        syncQueue.sync {
            storage[id]
        }
    }
}
