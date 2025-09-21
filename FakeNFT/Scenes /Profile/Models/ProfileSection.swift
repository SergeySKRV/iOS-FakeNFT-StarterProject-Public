//
//  ProfileSection.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 04.09.2025.
//

import Foundation

// MARK: - ProfileSection

/// Модель секции для экрана профиля.
///
/// Используется для построения таблицы (например, в `UITableView` или `UICollectionView`),
/// где каждая секция имеет заголовок и список элементов.
struct ProfileSection {
    // MARK: - Properties

    /// Заголовок секции (например, «Мои NFT», «Избранное»).
    let title: String

    /// Элементы внутри секции.
    let items: [ProfileItem]
}
