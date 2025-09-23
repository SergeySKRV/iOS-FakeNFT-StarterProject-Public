import Foundation

// MARK: - ServicesAssembly
final class ServicesAssembly {

    // MARK: - Properties
    private let networkClient: NetworkClientProtocol
    private let nftStorage: NftStorage
    private let userProfileService: UserProfileService

    // MARK: - Initialization
    init(
        networkClient: NetworkClientProtocol,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.userProfileService = UserProfileServiceImpl(networkClient: networkClient)
    }

    // MARK: - Public Methods
    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }

    var userService: UserProfileService {
        userProfileService
    }
}
