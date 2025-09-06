import Foundation

protocol UsersStorage: AnyObject {
    func saveUsers(_ users: [User])
    func getUsers() -> [User]?
}

final class UsersStorageImpl: UsersStorage {
    // MARK: public properties
    static let shared = UsersStorageImpl()
    // MARK: private properties
    private var storage: [User] = []
    private let syncQueue = DispatchQueue(label: "sync-users-queue")
    // MARK: private methods
    private init() {
    }
    // MARK: public methods
    func saveUsers(_ users: [User]) {
        syncQueue.async { [weak self] in
            self?.storage = users
        }
    }
    func getUsers() -> [User]? {
        syncQueue.sync {
            storage
        }
    }
}
