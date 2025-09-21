import Foundation

// MARK: - Type Aliases

/// Колбэк для загрузки одного NFT.
/// Возвращает результат с объектом `Nft` или ошибкой.
typealias NftCompletion = (Result<Nft, Error>) -> Void

/// Колбэк для загрузки списка всех NFT.
/// Возвращает результат с массивом `[Nft]` или ошибкой.
typealias AllNftsCompletion = (Result<[Nft], Error>) -> Void

// MARK: - NftService

/// Сервис для работы с NFT.
///
/// Предоставляет методы для загрузки одного NFT или списка всех NFT.
/// Может использовать кеширование (`NftStorage`).
protocol NftService {
    // MARK: - Public Methods

    /// Загружает конкретный NFT по идентификатору.
    /// - Parameters:
    ///   - id: Идентификатор NFT.
    ///   - completion: Колбэк с результатом (`Nft` или `Error`).
    func loadNft(id: String, completion: @escaping NftCompletion)

    /// Загружает список всех доступных NFT.
    /// - Parameter completion: Колбэк с результатом (массив `[Nft]` или `Error`).
    func loadAllNfts(completion: @escaping AllNftsCompletion)
}

// MARK: - NftServiceImpl

/// Реализация `NftService`, основанная на сетевом клиенте и локальном кеше.
final class NftServiceImpl: NftService {
    // MARK: - Properties

    /// Сетевой клиент для выполнения HTTP-запросов.
    private let networkClient: NetworkClientProtocol

    /// Хранилище для кеширования загруженных NFT.
    private let storage: NftStorage

    // MARK: - Initialization

    /// Создаёт сервис для работы с NFT.
    /// - Parameters:
    ///   - networkClient: Реализация `NetworkClientProtocol`.
    ///   - storage: Локальное хранилище NFT.
    init(networkClient: NetworkClientProtocol, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    // MARK: - Public Methods

    /// Загружает конкретный NFT по идентификатору.
    /// Сначала проверяет локальное хранилище, затем выполняет сетевой запрос при необходимости.
    /// - Parameters:
    ///   - id: Идентификатор NFT.
    ///   - completion: Колбэк с результатом (`Nft` или `Error`).
    func loadNft(id: String, completion: @escaping NftCompletion) {
        // Проверка локального кеша
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }

        // Если в кеше нет — запрос к API
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

    /// Загружает список всех доступных NFT с сервера.
    /// - Parameter completion: Колбэк с результатом (массив `[Nft]` или `Error`).
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
