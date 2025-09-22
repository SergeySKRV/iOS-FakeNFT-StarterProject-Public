import Foundation

protocol UsersListStorage: AnyObject {
    func getUsersList() -> [User]?
}

// Пример простого класса, который сохраняет данные из сети
final class UsersListImpl: UsersListStorage {
    private var storage: [String: User] = [:]

    private let syncQueue = DispatchQueue(label: "sync-nft-queue")

    func getUsersList() -> [UsersListImpl] {
        syncQueue.sync {
            storage[id]
        }
    }
}
