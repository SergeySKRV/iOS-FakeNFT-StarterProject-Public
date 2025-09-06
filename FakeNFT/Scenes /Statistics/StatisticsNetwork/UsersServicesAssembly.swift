final class UsersServicesAssembly {
    // MARK: private properties
    private let networkClient: NetworkClient
    private let usersStorage: UsersStorage
    // MARK: public methods
    init(
        networkClient: NetworkClient,
        usersStorage: UsersStorage
    ) {
        self.networkClient = networkClient
        self.usersStorage = usersStorage
    }
    var usersService: UsersService {
        UsersServiceImpl(
            networkClient: networkClient,
            storage: usersStorage
        )
    }
}
