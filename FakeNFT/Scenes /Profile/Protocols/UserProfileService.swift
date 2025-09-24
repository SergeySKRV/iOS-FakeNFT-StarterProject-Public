//
//  UserProfileService.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 10.09.2025.
//

import Foundation

// MARK: - UserProfileService

/// Сервис для работы с профилем пользователя.
///
/// Отвечает за загрузку, обновление и локальное сохранение данных профиля,
/// а также за управление списком «лайкнутых» NFT.
protocol UserProfileService {
    // MARK: - Remote Operations

    /// Загружает профиль пользователя с сервера.
    /// - Parameter completion: Колбэк с результатом:
    ///   - `.success(UserProfile)` — если профиль успешно получен,
    ///   - `.failure(Error)` — если произошла ошибка сети или парсинга.
    func fetchUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void)

    /// Обновляет профиль пользователя на сервере.
    /// - Parameters:
    ///   - profile: Новый объект профиля.
    ///   - completion: Колбэк с результатом:
    ///     - `.success(true)` — если обновление успешно,
    ///     - `.failure(Error)` — если произошла ошибка.
    func updateUserProfile(_ profile: UserProfile, completion: @escaping (Result<Bool, Error>) -> Void)

    // MARK: - Local Persistence

    /// Сохраняет профиль пользователя локально (например, в `UserDefaults`).
    /// - Parameter profile: Профиль для сохранения.
    /// - Returns: `true`, если операция успешна, иначе `false`.
    func saveUserProfileLocally(_ profile: UserProfile) -> Bool

    /// Загружает локально сохранённый профиль пользователя.
    /// - Returns: Экземпляр `UserProfile` или `nil`, если профиль не найден.
    func loadUserProfileLocally() -> UserProfile?

    // MARK: - Likes Handling

    /// Обновляет список «лайкнутых» NFT у пользователя.
    /// - Parameters:
    ///   - nftId: Идентификатор NFT.
    ///   - isLiked: Флаг добавления (`true`) или удаления (`false`) NFT из списка.
    ///   - completion: Колбэк с результатом:
    ///     - `.success(true)` — если обновление успешно,
    ///     - `.failure(Error)` — если произошла ошибка.
    func updateUserLikes(
        nftId: String,
        isLiked: Bool,
        completion: @escaping (Result<Bool, Error>) -> Void
    )
}
