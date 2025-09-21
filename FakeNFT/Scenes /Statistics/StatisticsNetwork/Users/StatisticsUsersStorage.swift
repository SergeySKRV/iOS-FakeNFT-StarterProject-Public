import Foundation

protocol StatisticsUsersStorage: AnyObject {
    func saveUsers(_ users: [StatisticsUser])
    func getUsers() -> [StatisticsUser]?
}

final class StatisticsUsersStorageImpl: StatisticsUsersStorage {
    // MARK: - public properties
    static let shared = StatisticsUsersStorageImpl()
    // MARK: - private properties
    private var storage: [StatisticsUser] = []
    private let syncQueue = DispatchQueue(label: "sync-users-queue")
    // MARK: - private methods
    private init() {
    }
    // MARK: - public methods
    func saveUsers(_ users: [StatisticsUser]) {
        syncQueue.async { [weak self] in
            self?.storage = users
        }
    }
    func getUsers() -> [StatisticsUser]? {
        syncQueue.sync {
            storage
        }
    }
}
