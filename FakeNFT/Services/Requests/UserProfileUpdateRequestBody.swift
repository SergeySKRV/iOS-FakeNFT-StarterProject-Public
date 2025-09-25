//
//  UserProfileUpdateRequestBody.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 17.09.2025.
//

import Foundation

// MARK: - UserProfileUpdateRequestBody

/// Тело запроса для обновления профиля пользователя.
///
/// Содержит данные: имя, описание, сайт и аватар.
/// Используется в `UpdateUserProfileRequest`.
struct UserProfileUpdateRequestBody: RequestBodyConvertible {
    // MARK: - Properties

    /// Имя пользователя.
    let name: String?

    /// Описание (био).
    let description: String?

    /// Сайт.
    let website: String?

    /// URL-строка аватара.
    let avatar: String?

    // MARK: - RequestBodyConvertible

    func asDictionary() -> [String: String] {
        var dict: [String: String] = [:]
        if let name = name { dict["name"] = name }
        if let description = description { dict["description"] = description }
        if let website = website { dict["website"] = website }
        if let avatar = avatar {
            dict["avatar"] = avatar
        } else {
            dict["avatar"] = "null"
        }
        return dict
    }

    func asJSONData() -> Data? { nil }

    var contentType: String { "application/x-www-form-urlencoded" }
}
