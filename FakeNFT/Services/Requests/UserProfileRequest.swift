//
//  UserProfileRequest.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 10.09.2025.
//

import Foundation

// MARK: - UserProfileRequest

/// Запрос для получения профиля пользователя.
///
/// Выполняет `GET`-запрос к эндпоинту:
/// `/api/v1/profile/{id}`
///
/// В данном примере `id` жёстко задан как `"1"`.
/// В реальном проекте параметр `id` лучше передавать снаружи.
struct UserProfileRequest: NetworkRequest {
    // MARK: - Properties

    /// Идентификатор профиля пользователя (здесь жёстко задан).
    private let profileId = "1"

    // MARK: - NetworkRequest

    /// Конечная точка запроса (например, `/api/v1/profile/1`).
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(profileId)")
    }

    /// HTTP-метод запроса (`GET`).
    var httpMethod: HttpMethod = .get

    /// Тело запроса (`nil`, так как это `GET`).
    var body: RequestBodyConvertible? { nil }
}
