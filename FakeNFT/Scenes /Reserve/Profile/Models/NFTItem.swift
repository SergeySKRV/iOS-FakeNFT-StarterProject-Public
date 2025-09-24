//
//  NFTItem.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 07.09.2025.
//

import Foundation

// MARK: - NFTItem

/// UI-модель для отображения NFT в списках и коллекциях.
///
/// Используется в экранах «Мои NFT» и «Избранные NFT».
struct NFTItem {
    // MARK: - Properties

    /// Уникальный идентификатор NFT.
    let id: String

    /// Название NFT или коллекции.
    let name: String

    /// Рейтинг NFT (например, от 0 до 5).
    let rating: Double

    /// Автор или создатель NFT.
    let author: String

    /// Цена NFT (строкой, например `"1.5 ETH"`).
    let price: String

    /// Ссылка на изображение NFT.
    let imageUrl: URL
}
