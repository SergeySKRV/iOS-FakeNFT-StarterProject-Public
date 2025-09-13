import Foundation

// MARK: - Type Aliases
typealias NftCompletion = (Result<Nft, Error>) -> Void
typealias AllNftsCompletion = (Result<[Nft], Error>) -> Void

// MARK: - NftService
protocol NftService {
    // MARK: - Public Methods
    func loadNft(id: String, completion: @escaping NftCompletion)
    func loadAllNfts(completion: @escaping AllNftsCompletion)
}

// MARK: - NftServiceImpl
final class NftServiceImpl: NftService {
    // MARK: - Properties
    private let networkClient: NetworkClient
    private let storage: NftStorage

    // MARK: - Initialization
    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    // MARK: - Public Methods
    func loadNft(id: String, completion: @escaping NftCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }
      
        let request = NFTRequest(id: id)
        
        networkClient.send(request: request, type: Nft.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadAllNfts(completion: @escaping AllNftsCompletion) {
        let request = AllNFTsRequest()
        
        networkClient.send(request: request, type: [Nft].self) { result in
            switch result {
            case .success(let nfts):
                completion(.success(nfts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
