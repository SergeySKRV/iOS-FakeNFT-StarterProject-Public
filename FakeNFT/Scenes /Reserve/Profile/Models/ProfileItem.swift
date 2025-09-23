//
//  ProfileItem.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 04.09.2025.
//

import Foundation

// MARK: - ProfileItem

/// Модель элемента профиля.
///
/// Используется внутри `ProfileSection` для отображения строк таблицы.
/// Каждый элемент имеет заголовок и подзаголовок.
struct ProfileItem {
    // MARK: - Properties

    /// Основной текст элемента (например, название NFT или параметра профиля).
    let title: String

    /// Дополнительный текст (например, описание, рейтинг или цена).
    let subtitle: String
}
