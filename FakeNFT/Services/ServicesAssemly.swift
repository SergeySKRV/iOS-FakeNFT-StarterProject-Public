import Foundation

// MARK: - ServicesAssembly
final class ServicesAssembly {
    
    // MARK: - Properties
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let userProfileService: UserProfileService
    
    // MARK: - Initialization
    init(
        networkClient: NetworkClient,
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
