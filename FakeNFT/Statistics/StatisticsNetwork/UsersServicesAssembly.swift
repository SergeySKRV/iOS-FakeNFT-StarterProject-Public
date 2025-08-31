final class UsersServicesAssembly {

    private let networkClient: NetworkClient
    private let usersStorage: UsersStorage

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
