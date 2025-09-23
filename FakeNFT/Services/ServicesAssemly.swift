final class ServicesAssembly {

    private let networkClient: NetworkClientProtocol
    private let nftStorage: NftStorage

    init(
        networkClient: NetworkClientProtocol,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
}
