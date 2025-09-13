//
//  NFTSortOption.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 09.09.2025.
//

import Foundation

// MARK: - NFTSortOption
enum NFTSortOption: CaseIterable {
    // MARK: - Cases
    case byPrice
    case byRating
    case byName
    
    // MARK: - Computed Properties
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
