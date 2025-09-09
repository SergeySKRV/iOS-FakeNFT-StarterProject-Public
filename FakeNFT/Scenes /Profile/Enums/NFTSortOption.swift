//
//  NFTSortOption.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 09.09.2025.
//

import Foundation

enum NFTSortOption: CaseIterable {
    case byPrice
    case byRating
    case byName 
    
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
