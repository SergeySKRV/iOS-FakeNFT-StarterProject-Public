import Foundation

typealias UsersCompletion = (Result<[User], Error>) -> Void

protocol UsersService {
    func loadUsers(completion: @escaping UsersCompletion)
}

final class UsersServiceImpl: UsersService {
    
    //MARK: private properties
    private let networkClient: NetworkClient
    private let storage: UsersStorage
    
    //MARK: public methods
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
}
