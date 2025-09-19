//
//  AllNFTsRequest.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 10.09.2025.
//

import Foundation

// MARK: - AllNFTsRequest

/// Запрос для получения списка всех доступных NFT.
///
/// Выполняет `GET`-запрос к эндпоинту:
/// `/api/v1/nft`
struct AllNFTsRequest: NetworkRequest {
    // MARK: - NetworkRequest Properties

    /// Конечная точка запроса (например, `/api/v1/nft`).
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft")
    }

    /// HTTP-метод запроса (`GET`).
    var httpMethod: HttpMethod = .get

    /// Тело запроса (для `GET` обычно `nil`).
    var body: RequestBodyConvertible?
}
