import Foundation

typealias StatisticsNftCompletion = (Result<StatisticsNft, Error>) -> Void

protocol StatisticsNftService {
    func loadNft(id: String, completion: @escaping StatisticsNftCompletion)
}

final class StatisticsNftServiceImpl: StatisticsNftService {
    
    private let networkClient: StatisticsNetworkClient
    private let storage: StatisticsNftStorage

    init(networkClient: StatisticsNetworkClient, storage: StatisticsNftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadNft(id: String, completion: @escaping StatisticsNftCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }

        let request = StatisticsNFTRequest(id: id)
        networkClient.send(request: request, type: StatisticsNft.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
