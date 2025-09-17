final class UsersServicesAssembly {
    // MARK: - private properties
    private let networkClient: NetworkClient
    private let usersStorage: StatisticsUsersStorage
    // MARK: - public methods
    init(
        networkClient: NetworkClient,
        usersStorage: StatisticsUsersStorage
    ) {
        self.networkClient = networkClient
        self.usersStorage = usersStorage
    }
    var usersService: StatisticsUsersService {
        StatisticsUsersServiceImpl(
            networkClient: networkClient,
            storage: usersStorage
        )
    }
}
