import Foundation

/// Запрос для получения информации об одном NFT.
struct NFTRequest: NetworkRequest {
    /// Идентификатор NFT.
    let id: String

    /// Конечная точка запроса (например, `/api/v1/nft/{id}`).
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }

    /// Для `GET`-запроса тело не требуется.
    var body: RequestBodyConvertible? { nil }
}
