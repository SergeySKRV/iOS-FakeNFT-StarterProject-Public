//
//  NFTSortOption.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 09.09.2025.
//

import Foundation

// MARK: - NFTSortOption

/// Варианты сортировки списка NFT.
///
/// Используется в экранах «Мои NFT» и «Избранные NFT»
/// для отображения пользователю различных способов сортировки.
enum NFTSortOption: CaseIterable {
    // MARK: - Cases

    /// Сортировка по цене (возрастание/убывание).
    case byPrice

    /// Сортировка по рейтингу (например, популярность, лайки).
    case byRating

    /// Сортировка по названию (алфавит).
    case byName

    // MARK: - Computed Properties

    /// Локализованное название опции сортировки.
    var title: String {
        switch self {
        case .byPrice:
            return NSLocalizedString("Sort.byPrice", comment: "Сортировка по цене")
        case .byRating:
            return NSLocalizedString("Sort.byRating", comment: "Сортировка по рейтингу")
        case .byName:
            return NSLocalizedString("Sort.byName", comment: "Сортировка по названию")
        }
    }
}
