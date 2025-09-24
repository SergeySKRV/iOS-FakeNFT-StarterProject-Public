//
//  UserLikesUpdateRequestBody.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 17.09.2025.
//

import Foundation

// MARK: - UserLikesUpdateRequestBody

/// Тело запроса для обновления списка лайкнутых NFT пользователя.
///
/// Реализует протокол `RequestBodyConvertible` и
/// подготавливает данные в формате `application/x-www-form-urlencoded`.
///
/// Используется в `UpdateUserProfileRequest`.
struct UserLikesUpdateRequestBody: RequestBodyConvertible {
    // MARK: - Properties

    /// Список идентификаторов лайкнутых NFT.
    let likes: [String]

    // MARK: - Public methods

    /// Преобразует тело запроса в словарь для `x-www-form-urlencoded`.
    ///
    /// - Если массив `likes` пустой → `["likes": "null"]`.
    /// - Если содержит элементы → идентификаторы объединяются в строку через запятую.
    ///
    /// Примеры:
    /// ```swift
    /// UserLikesUpdateRequestBody(likes: []).asDictionary()
    /// // ["likes": "null"]
    ///
    /// UserLikesUpdateRequestBody(likes: ["1", "2", "3"]).asDictionary()
    /// // ["likes": "1,2,3"]
    /// ```
    func asDictionary() -> [String: String] {
        if likes.isEmpty {
            return ["likes": "null"]
        } else {
            return ["likes": likes.joined(separator: ",")]
        }
    }

    /// JSON-сериализация не используется, всегда возвращает `nil`.
    func asJSONData() -> Data? { nil }

    /// MIME-тип для тела запроса.
    var contentType: String { "application/x-www-form-urlencoded" }
}
