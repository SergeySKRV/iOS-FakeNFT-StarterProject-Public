//
//  UpdateUserProfileRequest.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 11.09.2025.
//

import Foundation

// MARK: - UpdateUserProfileRequest

/// Запрос для обновления данных профиля пользователя.
///
/// Выполняет `PUT`-запрос к эндпоинту:
/// `/api/v1/profile/{id}`
///
/// Может обновлять как общие данные профиля (имя, описание, сайт, аватар),
/// так и список лайкнутых NFT.
struct UpdateUserProfileRequest: NetworkRequest {
    // MARK: - Properties

    /// Идентификатор профиля пользователя.
    private let profileId: String

    /// Данные для обновления.
    private let requestBody: RequestBodyConvertible?

    // MARK: - Lifecycle

    /// Инициализация запроса для обновления профиля.
    /// - Parameters:
    ///   - profileId: Идентификатор профиля (по умолчанию `"1"`).
    ///   - updateData: Данные для обновления (`UserProfileUpdateRequestBody`).
    init(profileId: String = "1", updateData: UserProfileUpdateRequestBody? = nil) {
        self.profileId = profileId
        self.requestBody = updateData
    }

    /// Инициализация запроса для обновления лайков пользователя.
    /// - Parameters:
    ///   - profileId: Идентификатор профиля (по умолчанию `"1"`).
    ///   - likes: Список идентификаторов лайкнутых NFT.
    init(profileId: String = "1", likes: [String]) {
        self.profileId = profileId
        self.requestBody = UserLikesUpdateRequestBody(likes: likes)
    }

    // MARK: - NetworkRequest Properties

    /// Конечная точка запроса (например, `/api/v1/profile/1`).
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(profileId)")
    }

    /// HTTP-метод (`PUT`).
    var httpMethod: HttpMethod = .put

    /// Тело запроса.
    var body: RequestBodyConvertible? {
        requestBody
    }
}
