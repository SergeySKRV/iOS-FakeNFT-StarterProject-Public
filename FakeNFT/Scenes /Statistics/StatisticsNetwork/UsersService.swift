import Foundation

typealias UsersCompletion = (Result<[User], Error>) -> Void

protocol UsersService {
    func loadUsers(completion: @escaping UsersCompletion)
    func loadProfile(id: Int, completion: @escaping (Result<User, Error>) -> Void)
    func loadNft(id: String, completion: @escaping (Result<Nft, Error>) -> Void)
}

final class UsersServiceImpl: UsersService {
    
    
    // MARK: - private properties
    private let networkClient: NetworkClient
    private let storage: UsersStorage
    // MARK: - public methods
    init(networkClient: NetworkClient, storage: UsersStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    func loadUsers(completion: @escaping UsersCompletion) {
        let request = ProfilesRequest()
        
        networkClient.send(request: request, type: [User].self) { [weak storage] result in
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
        networkClient.send(request: request, type: Nft.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                // storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func loadProfile(id: Int, completion: @escaping (Result<User, any Error>) -> Void) {
            
        }
}
