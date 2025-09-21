import Foundation

typealias StatisticsUsersCompletion = (Result<[StatisticsUser], Error>) -> Void

protocol StatisticsUsersService {
    func loadUsers(completion: @escaping StatisticsUsersCompletion)
    func loadProfile(completion: @escaping (Result<StatisticsProfile, Error>) -> Void)
    func loadNft(id: String, completion: @escaping (Result<StatisticsNft, Error>) -> Void)
}

final class StatisticsUsersServiceImpl: StatisticsUsersService {
    // MARK: - private properties
    private let networkClient: NetworkClient
    private let storage: StatisticsUsersStorage
    // MARK: - public methods
    init(networkClient: NetworkClient, storage: StatisticsUsersStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    func loadUsers(completion: @escaping StatisticsUsersCompletion) {
        let request = StatisticsUsersRequest()
        networkClient.send(request: request, type: [StatisticsUser].self) { [weak storage] result in
            switch result {
            case .success(let users):
                storage?.saveUsers(users)
                completion(.success(users))
            case .failure(let error):
                print("Error: \(error)")
                completion(.failure(error))
            }
        }
    }
    func loadNft(id: String, completion: @escaping NftCompletion) {
        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: StatisticsNft.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                // storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func loadProfile(completion: @escaping (Result<StatisticsProfile, any Error>) -> Void) {
        let request = StatisticsProfileRequest()
        networkClient.send(request: request, type: StatisticsProfile.self) { [weak storage] result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                print("Error: \(error)")
                completion(.failure(error))
            }
        }
    }
    func putProfile(likes: [String], completion: @escaping (Result<StatisticsProfile, any Error>) -> Void) {
        let param = likes.isEmpty ? "null" : likes.joined(separator: ",")
        let dto = StatisticsProfileDtoObject(param1: param)
        let request = StatisticsProfilePutRequest(dto: dto)
        networkClient.send(request: request, type: StatisticsProfile.self) { [weak storage] result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                print("Error: \(error)")
                completion(.failure(error))
            }
        }
    }
    func getOrders(completion: @escaping (Result<StatisticsOrder, any Error>) -> Void) {
        let request = StatisticsOrderRequest()
        networkClient.send(request: request, type: StatisticsOrder.self) { [weak storage] result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                print("Error: \(error)")
                completion(.failure(error))
            }
        }
    }
    func putOrders(order: [String], completion: @escaping (Result<StatisticsOrder, any Error>) -> Void) {
        let param = order.isEmpty ? "null" : order.joined(separator: ", ")
        let dto = StatisticsOrderDtoObject(param1: param)
        let request = StatisticsOrderPutRequest(dto: dto)
        networkClient.send(request: request, type: StatisticsOrder.self) { [weak self] result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                print("Error: \(error)")
                completion(.failure(error))
            }
        }
    }
}
