//
//  TabBarController+Types.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 22.09.2025.
//

import UIKit

// MARK: - Tab Enum
enum Tab {
    case catalog
    case cart
    case profile
    case statistics
    
    var titleKey: String {
        switch self {
        case .catalog: return "Tab.catalog"
        case .cart: return "Tab.cart"
        case .profile: return "Tab.profile"
        case .statistics: return "Tab.statistics"
        }
    }
    
    var inactiveImageName: String {
        switch self {
        case .catalog: return "catalogNoActive"
        case .cart: return "basketNoActive"
        case .profile: return "profileNoActive"
        case .statistics: return "tabStatistic"
        }
    }
    
    var activeImageName: String {
        switch self {
        case .catalog: return "catalogActive"
        case .cart: return "basketActive"
        case .profile: return "profileActive"
        case .statistics: return "tabStatistic"
        }
    }
}

extension Notification.Name {
    static let cartItemCountDidChange = Notification.Name("cartItemCountDidChange")
    static let unreadMessagesCountDidChange = Notification.Name("unreadMessagesCountDidChange")
}
