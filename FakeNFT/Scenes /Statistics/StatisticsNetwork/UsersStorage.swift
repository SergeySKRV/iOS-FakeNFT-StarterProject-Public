import Foundation

protocol UsersStorage: AnyObject {
    func saveUsers(_ users: [User])
    func getUsers() -> [User]?
}



final class UsersStorageImpl: UsersStorage {
    
    private var storage: [User] = []
    
    static let shared = UsersStorageImpl()
    

    private let syncQueue = DispatchQueue(label: "sync-users-queue")

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
